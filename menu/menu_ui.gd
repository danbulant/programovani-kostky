extends Control

signal start_pressed

func _on_button_pressed() -> void:
	start_pressed.emit()
