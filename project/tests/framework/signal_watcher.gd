class_name SignalWatcher
extends RefCounted
## Records every emission of one signal, with its arguments, for a test to inspect.
##
## [codeblock]
## var refusals := SignalWatcher.watch(server.session_refused)
## assert_true(await wait_until(refusals.was_emitted))
## assert_eq(refusals.count(), 1)
## [/codeblock]

var _emissions: Array[Array] = []


static func watch(watched: Signal) -> SignalWatcher:
	var watcher := SignalWatcher.new()
	watched.connect(watcher.record)
	return watcher


## Records one emission. Public so it can stand in for any callback, whatever its arguments.
func record(...args: Array) -> void:
	_emissions.append(args)


func count() -> int:
	return _emissions.size()


func was_emitted() -> bool:
	return not _emissions.is_empty()


## The arguments of emission [param index], in order.
func arguments(index: int) -> Array:
	return _emissions[index]
