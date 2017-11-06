-- Luarocks rockspec details
package = "kong-plugin-options-preflight"
version = "0.1.0-0"
supported_platforms = {"linux", "macosx"}
source = {
	url = "git@github.com:thomasgriffin/kong-plugin-options-preflight.git",
	tag = "0.1.0"
}
description = {
	summary = "Kong plugin that handles responding to OPTIONS preflight requests. This should be used in conjunction with the Kong CORS plugin.",
	license = "MIT"
}
local pluginName = "options-preflight"
build = {
	type = "builtin",
	modules = {
		["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
		["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua"
	}
}