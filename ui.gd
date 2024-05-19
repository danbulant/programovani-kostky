extends Control
class_name Ui

signal roll_pressed
func _on_roll_button_pressed() -> void:
	roll_pressed.emit()

@onready var current_throw_value = $current_throw_value

func set_current_throw_value(value: Array[int]) -> void:
	current_throw_value.set_text(str(value))
	pass