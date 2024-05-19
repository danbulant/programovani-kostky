extends Node3D

@onready var dice1: Dice = $dice1
@onready var dice2: Dice = $dice2
@onready var camera: Camera3D = $Camera3D
@onready var camera_start: Marker3D = $CameraPositionDefault
@onready var ui: Ui = $Ui

enum GameState {
	START,
	THROWING_START,
	THROWING,
	THROWN
}

var state: GameState = GameState.START

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if (!dice1.can_be_thrown() or !dice2.can_be_thrown()) and state == GameState.THROWING_START:
		state = GameState.THROWING
	if dice1.can_be_thrown() and dice2.can_be_thrown() and state == GameState.THROWING:
		state = GameState.THROWN
		var avg_position = (dice1.global_transform.origin + dice2.global_transform.origin) / 2
		var diff = dice1.global_position - dice2.global_position
		camera.global_position = avg_position + Vector3.UP * (diff.length())
		camera.look_at(avg_position, Vector3.FORWARD)

func throw_dice() -> void:
	if dice1.can_be_thrown() and dice2.can_be_thrown():
		dice1.random_throw()
		dice2.random_throw()
		state = GameState.THROWING_START
		reset_camera()

func reset_camera() -> void:
	camera.global_transform.origin = camera_start.global_transform.origin
	camera.global_transform.basis = camera_start.global_transform.basis
