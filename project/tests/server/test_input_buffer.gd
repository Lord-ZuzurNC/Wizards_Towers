extends TestCase
## The server's queue of movement inputs, one wizard each.


func test_inputs_come_out_in_order_one_at_a_time() -> void:
	var buffer := InputBuffer.new()
	assert_true(buffer.receive(1, PackedByteArray([5, 3])))
	assert_eq(buffer.take(), 5)
	assert_eq(buffer.last_applied, 1)
	assert_eq(buffer.take(), 3)
	assert_eq(buffer.last_applied, 2)
	assert_eq(buffer.take(), -1)


func test_repeated_inputs_are_kept_once() -> void:
	var buffer := InputBuffer.new()
	buffer.receive(1, PackedByteArray([5, 5, 5]))
	buffer.receive(2, PackedByteArray([5, 5, 7]))
	var taken := 0
	while buffer.take() >= 0:
		taken += 1
	assert_eq(taken, 4)
	assert_eq(buffer.last_applied, 4)


func test_an_invalid_code_rejects_the_whole_packet() -> void:
	var buffer := InputBuffer.new()
	assert_false(buffer.receive(1, PackedByteArray([5, 9])))
	assert_eq(buffer.take(), -1)


func test_an_empty_or_oversized_packet_is_rejected() -> void:
	var buffer := InputBuffer.new()
	assert_false(buffer.receive(1, PackedByteArray()))
	var too_many := PackedByteArray()
	too_many.resize(Protocol.MAX_INPUTS_PER_MESSAGE + 1)
	assert_false(buffer.receive(1, too_many))
	assert_false(buffer.receive(0, PackedByteArray([5])))


func test_a_flood_of_inputs_cannot_speed_a_wizard_up() -> void:
	var buffer := InputBuffer.new()
	for packet in 10:
		buffer.receive(1 + packet * 8, PackedByteArray([5, 5, 5, 5, 5, 5, 5, 5]))
	var taken := 0
	while buffer.take() >= 0:
		taken += 1
	assert_eq(taken, InputBuffer.MAX_QUEUED)
