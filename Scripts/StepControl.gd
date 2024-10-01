extends Node

signal request_next_step()

@export_enum("Input", "Process", "Timed")
var updateType: String = "Input":
	set(value):
		typeUpdated(updateType, value)
		updateType = value
## could make this a proper enum, or do anything to ensure correctness
## but I won't
## or maybe I will later, but not right now!

#I should pop these out into strategy nodes. Which might result in a class hierarchy which would make me sad
# or it could have no type safety whatsoever, which would also make me sad.
# such is life. I guess I can treat flat-ish hierarchies as interfaces as long as I use a parent node to string them together?
# a bunch of extra boilerplate, but it's not like gdscript is particularly verbose.

var _timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createTimer()

func createTimer() -> void:
	_timer = Timer.new()
	_timer.timeout.connect(_timer_event)
	_timer.wait_time = 0.5
	add_child(_timer)
	if updateType == "Timed":
		_timer.start()

func typeUpdated(oldType: String, type: String) -> void:
	if oldType == type:
		return
	if not is_node_ready():
		return
	if oldType == "Timed":
		_timer.stop()
	if type == "Timed":
		_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if updateType == "Process":
		print_debug("emitting next step signal via process")
		request_next_step.emit()

func _input(event: InputEvent) -> void:
	if updateType == "Input" and event.is_action_released("ui_accept"):
		print_debug("emitting next step signal via input")
		request_next_step.emit()

func _timer_event() -> void:
	print_debug("emitting next step signal via timer")
	request_next_step.emit()
	_timer.start()
