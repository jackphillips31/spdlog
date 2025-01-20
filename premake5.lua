project "spdlog"
	kind "StaticLib"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin/" .. outputdir .. "/%{prj.name}")

	files
	{
		"include/spdlog/async.h",
    "include/spdlog/async_logger.h",
    "include/spdlog/common.h",
    "include/spdlog/formatter.h",
    "include/spdlog/fwd.h",
    "include/spdlog/logger.h",
    "include/spdlog/pattern_formatter.h",
    "include/spdlog/source_loc.h",
    "include/spdlog/spdlog.h",
    "include/spdlog/stopwatch.h",
    "include/spdlog/version.h",
    "include/spdlog/cfg/argv.h",
    "include/spdlog/cfg/env.h",
    "include/spdlog/cfg/helpers.h",
    "include/spdlog/details/circular_q.h",
    "include/spdlog/details/file_helper.h",
    "include/spdlog/details/fmt_helper.h",
    "include/spdlog/details/log_msg.h",
    "include/spdlog/details/log_msg_buffer.h",
    "include/spdlog/details/mpmc_blocking_q.h",
    "include/spdlog/details/null_mutex.h",
    "include/spdlog/details/os.h",
    "include/spdlog/details/periodic_worker.h",
    "include/spdlog/details/registry.h",
    "include/spdlog/details/synchronous_factory.h",
    "include/spdlog/details/thread_pool.h",
    "include/spdlog/fmt/bin_to_hex.h",
    "include/spdlog/fmt/fmt.h",
    "include/spdlog/sinks/android_sink.h",
    "include/spdlog/sinks/base_sink.h",
    "include/spdlog/sinks/basic_file_sink.h",
    "include/spdlog/sinks/callback_sink.h",
    "include/spdlog/sinks/daily_file_sink.h",
    "include/spdlog/sinks/dist_sink.h",
    "include/spdlog/sinks/dup_filter_sink.h",
    "include/spdlog/sinks/hourly_file_sink.h",
    "include/spdlog/sinks/kafka_sink.h",
    "include/spdlog/sinks/mongo_sink.h",
    "include/spdlog/sinks/msvc_sink.h",
    "include/spdlog/sinks/null_sink.h",
    "include/spdlog/sinks/ostream_sink.h",
    "include/spdlog/sinks/qt_sinks.h",
    "include/spdlog/sinks/ringbuffer_sink.h",
    "include/spdlog/sinks/rotating_file_sink.h",
    "include/spdlog/sinks/sink.h",
    "include/spdlog/sinks/stdout_color_sinks.h",
    "include/spdlog/sinks/stdout_sinks.h",
    "include/spdlog/sinks/syslog_sink.h",
    "include/spdlog/sinks/systemd_sink.h",
    "include/spdlog/sinks/tcp_sink.h",
    "include/spdlog/sinks/udp_sink.h",
		"src/async_logger.cpp",
    "src/common.cpp",
    "src/logger.cpp",
    "src/pattern_formatter.cpp",
    "src/spdlog.cpp",
    "src/cfg/helpers.cpp",
    "src/details/file_helper.cpp",
    "src/details/log_msg.cpp",
    "src/details/log_msg_buffer.cpp",
    "src/details/periodic_worker.cpp",
    "src/details/registry.cpp",
    "src/details/thread_pool.cpp",
    "src/sinks/base_sink.cpp",
    "src/sinks/basic_file_sink.cpp",
    "src/sinks/rotating_file_sink.cpp",
    "src/sinks/sink.cpp",
    "src/sinks/stdout_color_sinks.cpp",
    "src/sinks/stdout_sinks.cpp"
	}

	includedirs
	{
		"include",
		"../fmt/include"
	}

	defines
	{
		"_CRT_SECURE_NO_WARNINGS",
		"FMT_UNICODE=0"
	}


	filter "system:windows"
		files
		{
			"include/spdlog/sinks/wincolor_sink.h",
			"include/spdlog/details/tcp_client_windows.h",
			"include/spdlog/details/udp_client_windows.h",
			"include/spdlog/details/windows_include.h",
			"include/spdlog/sinks/win_eventlog_sink.h",
			"src/details/os_windows.cpp",
			"src/sinks/wincolor_sink.cpp"
		}

	filter "system:linux"
		files
		{
			"include/spdlog/details/tcp_client_unix.h",
			"include/spdlog/details/udp_client_unix.h",
			"include/spdlog/sinks/ansicolor_sink.h",
			"src/details/os_unix.cpp",
			"src/sinks/ansicolor_sink.cpp"
		}

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "on"

  filter "configurations:Dist"
		runtime "Release"
		optimize "speed"