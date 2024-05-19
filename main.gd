extends Node3D

@onready var dice1: Dice = $dice1
@onready var dice2: Dice = $dice2
@onready var camera: Camera3D = $Camera3D
@onready var camera_starting: Marker3D = $CameraPositionStarting
@onready var camera_prethrow: Marker3D = $CameraPositionPrethrow
@onready var camera_target: Marker3D = $CameraPositionTarget
@onready var ui: Ui = $Ui

enum GameState {
	START,
	THROWING_START,
	THROWING,
	THROWN
}

var state: GameState = GameState.START
var camera_transition := 0.
var camera_speed := 1.5
var first_throw := true

func _ready() -> void:
	ui.connect("roll_pressed", throw_dice)

func _physics_process(delta: float) -> void:
	camera_transition += delta * camera_speed
	camera_transition = min(camera_transition, 1.)
	if state == GameState.THROWING_START or state == GameState.THROWING:
		camera.transform = ( camera_starting if first_throw else camera_target).transform.interpolate_with(camera_prethrow.transform, camera_transition)
	elif state == GameState.THROWN:
		camera.transform = camera_prethrow.transform.interpolate_with(camera_target.transform, camera_transition)

	if (!dice1.can_be_thrown() or !dice2.can_be_thrown()) and state == GameState.THROWING_START:
		state = GameState.THROWING
	if dice1.can_be_thrown() and dice2.can_be_thrown() and state == GameState.THROWING:
		state = GameState.THROWN
		var avg_position = (dice1.global_transform.origin + dice2.global_transform.origin) / 2
		var diff = dice1.global_position - dice2.global_position
		camera_target.global_position = avg_position + Vector3.UP * max(diff.length(), 0.1)
		camera_target.look_at(avg_position, Vector3.FORWARD)
		camera_transition = 0.
		first_throw = false

	ui.set_current_throw_value([dice1.get_value(), dice2.get_value()])

func throw_dice() -> void:
	if dice1.can_be_thrown() and dice2.can_be_thrown():
		dice1.random_throw()
		dice2.random_throw()
		state = GameState.THROWING_START
		camera_transition = 0.
