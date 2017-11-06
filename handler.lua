-- Load the base plugin and create a subclass.
local plugin    = require("kong.plugins.base_plugin"):extend()
local responses = require "kong.tools.responses"

-- Subclass constructor.
function plugin:new()
	plugin.super.new(self, "options-preflight")
end

-- Runs inside of the access_by_lua_block hook.
function plugin:access(config)
	plugin.super.access(self)

	-- If this is an OPTIONS request, go ahead and return.
	-- This plugin assumes that you have already configured the core Kong "cors"
	-- plugin to allow preflight requests and that preflight_continue is set
	-- to true. This plugin runs immediately after the "cors" plugin so that
	-- it can respond properly to the OPTIONS request and continue with
	-- whatever cross origin request you have made.
	if ngx.req.get_method() == "OPTIONS" then
		-- Set headers to allow the request to continue.
		ngx.header["Vary"] = "Origin"
		ngx.header["Content-Length"] = "0"
		ngz.header["Access-Control-Max-Age"] = "600"
		ngx.header["Access-Control-Allow-Origin"] = "*"
		ngx.header["Access-Control-Allow-Methods"] = "GET,HEAD,PUT,PATCH,POST,DELETE"
		ngx.header["Access-Control-Allow-Headers"] = "X-CSRF-Token,X-XSRF-Token,Bearer-Token,X-Auth-Token,Origin,X-Requested-With,Content-Type,Accept,Authorization"
		ngx.header["Access-Control-Allow-Credentials"] = "true"

		-- Exit the request.
		return responses.send_HTTP_OK()
	end
end

-- Set the plugin priority, which determines plugin execution order.
plugin.PRIORITY = 1999

-- Return our plugin object.
return plugin