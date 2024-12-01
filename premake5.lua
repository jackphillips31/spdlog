project "spdlog"
	kind "StaticLib"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin/" .. outputdir .. "/obj")

	files
	{
		"include/spdlog/**.h",
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
		"src/sinks/ansicolor_sink.cpp",
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
		systemversion "latest"
		files
		{
			"src/details/os_windows.cpp",
			"src/sinks/wincolor_sink.cpp"
		}

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "on"