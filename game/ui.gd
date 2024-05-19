extends Control
class_name Ui

signal roll_pressed
func _on_roll_button_pressed() -> void:
	roll_pressed.emit()

@onready var dice1 = $dice1
@onready var dice2 = $dice2

func set_current_throw_value(value: Array[int]) -> void:
	dice1.value = value[0]
	dice2.value = value[1]