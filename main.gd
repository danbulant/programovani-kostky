extends Node3D

@onready var dice: Dice = $dice1

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		dice.random_throw()

func _on_dice_1_sleeping_state_changed() -> void:
	pass