extends Control

class_name Ui

signal roll_pressed

func _on_roll_button_pressed() -> void:
	roll_pressed.emit()
