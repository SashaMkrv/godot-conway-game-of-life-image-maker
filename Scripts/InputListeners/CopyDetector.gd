extends Node

signal request_image_to_clipboard

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_copy"):
		request_image_to_clipboard.emit()
