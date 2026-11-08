extends TestCase
## The handshake messages, read and written without any network.


func test_a_hello_carries_its_version() -> void:
	assert_eq(Protocol.decode_hello(Protocol.encode_hello(42)), 42)


func test_a_hello_with_the_same_version_is_accepted() -> void:
	var hello := Protocol.encode_hello(Protocol.VERSION)
	assert_eq(Protocol.answer_hello(hello), Protocol.Answer.ACCEPTED)


func test_a_hello_with_another_version_is_refused() -> void:
	var hello := Protocol.encode_hello(Protocol.VERSION + 1)
	assert_eq(Protocol.answer_hello(hello), Protocol.Answer.REFUSED_VERSION)


func test_an_empty_hello_is_malformed() -> void:
	assert_eq(Protocol.decode_hello(PackedByteArray()), -1)
	assert_eq(Protocol.answer_hello(PackedByteArray()), Protocol.Answer.REFUSED_MALFORMED)


func test_a_hello_of_the_wrong_size_is_malformed() -> void:
	var hello := Protocol.encode_hello(Protocol.VERSION)
	hello.append(0)
	assert_eq(Protocol.answer_hello(hello), Protocol.Answer.REFUSED_MALFORMED)


func test_a_hello_without_the_magic_number_is_malformed() -> void:
	var hello := Protocol.encode_hello(Protocol.VERSION)
	hello[0] = hello[0] ^ 0xff
	assert_eq(Protocol.answer_hello(hello), Protocol.Answer.REFUSED_MALFORMED)


func test_an_answer_carries_the_decision_and_the_server_version() -> void:
	var data := Protocol.encode_answer(Protocol.Answer.REFUSED_VERSION, 7)
	var message := Protocol.decode_answer(data)
	assert_true(message != null)
	assert_eq(message.answer, Protocol.Answer.REFUSED_VERSION)
	assert_eq(message.server_version, 7)


func test_an_answer_with_an_unknown_decision_is_malformed() -> void:
	var data := Protocol.encode_answer(Protocol.Answer.ACCEPTED, Protocol.VERSION)
	data[4] = 99
	assert_true(Protocol.decode_answer(data) == null)


func test_a_truncated_answer_is_malformed() -> void:
	var data := Protocol.encode_answer(Protocol.Answer.ACCEPTED, Protocol.VERSION)
	assert_true(Protocol.decode_answer(data.slice(0, 5)) == null)


func test_a_version_refusal_names_both_versions() -> void:
	var reason := Protocol.describe_refusal(Protocol.Answer.REFUSED_VERSION, 3, 2)
	assert_true(reason.contains("3") and reason.contains("2"), reason)
