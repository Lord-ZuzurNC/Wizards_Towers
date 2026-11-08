class_name LaunchOptions
extends RefCounted
## The options given after [code]--[/code] on the command line, read once at start.
##
## [codeblock lang=text]
## --server          run as the game server instead of a client
## --host=<address>  the server a client joins, 127.0.0.1 by default
## --port=<number>   the port the server listens on, or the client joins
## [/codeblock]

var server := false
var host := "127.0.0.1"
var port := Protocol.DEFAULT_PORT
## One line per option that could not be understood. Empty when all went well.
var errors: PackedStringArray = []


static func parse(args: PackedStringArray) -> LaunchOptions:
	var options := LaunchOptions.new()
	for arg in args:
		if arg == "--server":
			options.server = true
		elif arg.begins_with("--host="):
			options.host = arg.trim_prefix("--host=")
			if options.host.is_empty():
				options.errors.append("--host needs an address")
		elif arg.begins_with("--port="):
			var value := arg.trim_prefix("--port=")
			if not value.is_valid_int() or int(value) < 1 or int(value) > 65_535:
				options.errors.append("--port needs a number from 1 to 65535, got '%s'" % value)
			else:
				options.port = int(value)
		else:
			options.errors.append("unknown option '%s'" % arg)
	return options
