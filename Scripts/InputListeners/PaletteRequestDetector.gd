extends Node

signal paletteRequested()

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_text_backspace"):
		paletteRequested.emit()
