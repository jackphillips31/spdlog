// Copyright(c) 2015-present, Gabi Melman & spdlog contributors.
// Distributed under the MIT License (http://opensource.org/licenses/MIT)

#include "spdlog/details/file_helper.h"

#include <cerrno>
#include <cstdio>
#include <utility>

#include "spdlog/common.h"
#include "spdlog/details/os.h"

namespace spdlog {
namespace details {

file_helper::file_helper(file_event_handlers event_handlers)
    : event_handlers_(std::move(event_handlers)) {}

file_helper::~file_helper() { close(); }

void file_helper::open(const filename_t &fname, bool truncate) {
    close();
    filename_ = fname;

    const auto *mode = SPDLOG_FILENAME_T("ab");
    const auto *trunc_mode = SPDLOG_FILENAME_T("wb");

    if (event_handlers_.before_open) {
        event_handlers_.before_open(filename_);
    }
    for (int tries = 0; tries < open_tries_; ++tries) {
        // create containing folder if not exists already.
        os::create_dir(os::dir_name(fname));
        if (truncate) {
            // Truncate by opening-and-closing a tmp file in "wb" mode, always
            // opening the actual log-we-write-to in "ab" mode, since that
            // interacts more politely with eternal processes that might
            // rotate/truncate the file underneath us.
            std::FILE *tmp = nullptr;
            if (os::fopen_s(&tmp, fname, trunc_mode)) {
                continue;
            }
            std::fclose(tmp);
        }
        if (!os::fopen_s(&fd_, fname, mode)) {
            if (event_handlers_.after_open) {
                event_handlers_.after_open(filename_, fd_);
            }
            return;
        }

        details::os::sleep_for_millis(open_interval_);
    }

    throw_spdlog_ex("Failed opening file " + os::filename_to_str(filename_) + " for writing", errno);
}

void file_helper::reopen(bool truncate) {
    if (filename_.empty()) {
        throw_spdlog_ex("Failed re opening file - was not opened before");
    }
    this->open(filename_, truncate);
}

void file_helper::flush() const {
    if (std::fflush(fd_) != 0) {
        throw_spdlog_ex("Failed flush to file " + os::filename_to_str(filename_), errno);
    }
}

void file_helper::sync() const {
    if (!os::fsync(fd_)) {
        throw_spdlog_ex("Failed to fsync file " + os::filename_to_str(filename_), errno);
    }
}

void file_helper::close() {
    if (fd_ != nullptr) {
        if (event_handlers_.before_close) {
            event_handlers_.before_close(filename_, fd_);
        }

        std::fclose(fd_);
        fd_ = nullptr;

        if (event_handlers_.after_close) {
            event_handlers_.after_close(filename_);
        }
    }
}

void file_helper::write(const memory_buf_t &buf) const {
    if (fd_ == nullptr) return;
    const size_t msg_size = buf.size();
    const auto *data = buf.data();
    if (!os::fwrite_bytes(data, msg_size, fd_)) {
        throw_spdlog_ex("Failed writing to file " + os::filename_to_str(filename_), errno);
    }
}

size_t file_helper::size() const {
    if (fd_ == nullptr) {
        throw_spdlog_ex("Cannot use size() on closed file " + os::filename_to_str(filename_));
    }
    return os::filesize(fd_);
}

const filename_t &file_helper::filename() const { return filename_; }

//
// return file path and its extension:
//
// "mylog.txt" => ("mylog", ".txt")
// "mylog" => ("mylog", "")
// "mylog." => ("mylog.", "")
// "/dir1/dir2/mylog.txt" => ("/dir1/dir2/mylog", ".txt")
//
// the starting dot in filenames is ignored (hidden files):
//
// ".mylog" => (".mylog". "")
// "my_folder/.mylog" => ("my_folder/.mylog", "")
// "my_folder/.mylog.txt" => ("my_folder/.mylog", ".txt")
std::tuple<filename_t, filename_t> file_helper::split_by_extension(const filename_t &fname) {
    auto ext_index = fname.rfind('.');

    // no valid extension found - return whole path and empty string as
    // extension
    if (ext_index == filename_t::npos || ext_index == 0 || ext_index == fname.size() - 1) {
        return std::make_tuple(fname, filename_t());
    }

    // treat cases like "/etc/rc.d/somelogfile or "/abc/.hiddenfile"
    auto folder_index = fname.find_last_of(details::os::folder_seps_filename);
    if (folder_index != filename_t::npos && folder_index >= ext_index - 1) {
        return std::make_tuple(fname, filename_t());
    }

    // finally - return a valid base and extension tuple
    return std::make_tuple(fname.substr(0, ext_index), fname.substr(ext_index));
}

}  // namespace details
}  // namespace spdlog
