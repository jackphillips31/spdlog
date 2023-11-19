project "spdlog"
	kind "None"
	language "C++"
	cppdialect "C++11"

	files
	{
		"include/spdlog/**.h"
	}

	includedirs
	{
		"include"
	}

	filter "system:windows"
		systemversion "latest"

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "on"