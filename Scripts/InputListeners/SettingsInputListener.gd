@tool
extends Node



@onready
var seedInput: LineEdit = %SeedInput
@onready
var gridSizeInput: SpinBox = %GridSizeInput
@onready
var numberOfGamesInput: SpinBox = %NumberOfGamesInput
@onready
var showGhostInput: CheckBox = %ShowGhostInput
@onready
var logTextEdit: TextEdit = %LogTextEdit
@onready
var logContainer: Control = $LogMargin

@export
var firstFocusElement: Control


signal seedChanged(newSeed: String)
signal gridSizeChanged(newSize: int)
signal numberOfGamesChanged(newNumber: int)
signal showGhostChanged(newState: bool)

signal saveImageRequested()
signal nextRoundRequested()
signal newPaletteRequested()


var _logging:= false

func _ready() -> void:
	if not OS.has_feature("mobile"):
		if firstFocusElement != null:
			firstFocusElement.grab_focus()
	if not OS.has_feature("debug"):
		logContainer.visible = false
		_logging = false
	else:
		_logging = true

func _on_seed_input_text_changed(new_text: String) -> void:
	seedChanged.emit(new_text)


func _on_seed_input_focus_exited() -> void:
	if _logging:
		addToLogs("on text focus exited event success.")
	# HACK terrible things happening here on account of the thrills of web mobile
	var new_text = seedInput.text
	seedChanged.emit(new_text)


func _on_grid_size_input_value_changed(value: float) -> void:
	var newValue = int(value)
	gridSizeChanged.emit(newValue)


func _on_number_of_games_input_value_changed(value: float) -> void:
	var newValue = int(value)
	numberOfGamesChanged.emit(newValue)


func _on_show_ghost_input_toggled(toggled_on: bool) -> void:
	showGhostChanged.emit(toggled_on)

func _on_next_round_button_pressed() -> void:
	nextRoundRequested.emit()


func _on_new_palette_button_pressed() -> void:
	newPaletteRequested.emit()


func _on_save_image_button_pressed() -> void:
	saveImageRequested.emit()


func updateSeed(newValue: String) -> void:
	seedInput.text = newValue
	# oh no, would these ones emit the value changed events?????


func updateGridSize(newValue: int) -> void:
	gridSizeInput.value = newValue


func updateNumberOfGames(newValue: int) -> void:
	numberOfGamesInput.value = newValue


func updateShowGhost(newValue: bool) -> void:
	showGhostInput.button_pressed = newValue


func addToLogs(text: String) -> void:
	logTextEdit.insert_text(text + "\n", 0, 0)
