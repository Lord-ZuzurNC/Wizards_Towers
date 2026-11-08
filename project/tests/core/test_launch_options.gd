extends TestCase
## Reading the command-line options.


func test_no_option_means_a_client_on_the_defaults() -> void:
	var options := LaunchOptions.parse(PackedStringArray())
	assert_false(options.server)
	assert_eq(options.host, "127.0.0.1")
	assert_eq(options.port, Protocol.DEFAULT_PORT)
	assert_eq(options.errors.size(), 0)


func test_every_option_is_read() -> void:
	var args := PackedStringArray(["--server", "--host=10.0.0.5", "--port=7800"])
	var options := LaunchOptions.parse(args)
	assert_true(options.server)
	assert_eq(options.host, "10.0.0.5")
	assert_eq(options.port, 7800)
	assert_eq(options.errors.size(), 0)


func test_a_port_out_of_range_is_an_error() -> void:
	for bad: String in ["--port=0", "--port=65536", "--port=abc", "--port="]:
		var options := LaunchOptions.parse(PackedStringArray([bad]))
		assert_eq(options.errors.size(), 1, bad)
		assert_eq(options.port, Protocol.DEFAULT_PORT, bad)


func test_an_empty_host_is_an_error() -> void:
	assert_eq(LaunchOptions.parse(PackedStringArray(["--host="])).errors.size(), 1)


func test_an_unknown_option_is_an_error() -> void:
	var options := LaunchOptions.parse(PackedStringArray(["--sever"]))
	assert_eq(options.errors.size(), 1)
	assert_true(options.errors[0].contains("--sever"), options.errors[0])
