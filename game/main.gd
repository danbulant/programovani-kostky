extends Node3D

@onready var dice1: Dice = $dice1
@onready var dice2: Dice = $dice2
@onready var camera: Camera3D = $Camera3D
@onready var camera_starting: Marker3D = $CameraPositionStarting
@onready var camera_prethrow: Marker3D = $CameraPositionPrethrow
@onready var camera_target: Marker3D = $CameraPositionTarget
@onready var ui: Ui = $Ui
@onready var gamescene_light = $GameSceneLight
@onready var menu_scene = $MenuBg
@onready var player_select = $PlayerSelect

const physics_timeout := 2.5

enum GameState {
	START,
	THROWING_START,
	THROWING,
	THROWN
}

enum MasterState {
	LOGO,
	PLAYER_SELECT,
	GAME
}

var state: GameState = GameState.START
var master_state: MasterState = MasterState.LOGO
var current_player = 0
var camera_transition := 0.
var camera_speed := 1.5
var first_throw := true
var physics_timer := Timer.new()
var target_score = 100

func _ready() -> void:
	ui.connect("roll_pressed", throw_dice)
	add_child(physics_timer)
	physics_timer.connect("timeout", physics_timer_timeout)
	menu_scene.connect("start_game", switch_to_player_select)
	player_select.connect("start_game", switch_to_game)
	player_select.connect("back_to_menu", switch_to_menu)
	ui.connect("back_to_menu", switch_to_menu)
	switch_to_menu()

func master_state_sync() -> void:
	ui.visible = MasterState.GAME == master_state
	gamescene_light.visible = MasterState.GAME == master_state
	menu_scene.visible = MasterState.LOGO == master_state
	menu_scene.ui_visible = MasterState.LOGO == master_state
	player_select.visible = MasterState.PLAYER_SELECT == master_state
	if master_state != MasterState.GAME:
		physics_timer_timeout()
	ui.update_medal()

func switch_to_player_select() -> void:
	master_state = MasterState.PLAYER_SELECT
	master_state_sync()

func switch_to_game() -> void:
	master_state = MasterState.GAME
	# for i in ui.players.size():
	# 	ui.players[i].player_name = ""
	for i in player_select.player_names.size():
		var player_name: String = player_select.player_names[i]
		# if not player_name: continue
		ui.players[i].player_name = player_name
		ui.players[i].score = 0
		ui.players[i].show_medal = false
	for i in player_select.player_names.size():
		if player_select.player_names[i]:
			current_player = i
			break
	master_state_sync()

func switch_to_menu() -> void:
	master_state = MasterState.LOGO
	master_state_sync()

func physics_timer_timeout() -> void:
	dice1.sleeping = true
	dice2.sleeping = true
	pass

func next_player() -> void:
	current_player = (current_player + 1) % ui.players.size()
	if not ui.players[current_player].player_name:
		var found = false
		for i in player_select.player_names:
			if i:
				found = true
				break
		if not found:
			print("Trying to run next_player with no players! Semi-crashing to main menu.")
			switch_to_menu()
			return
		next_player()

func check_score() -> void:
	for i in ui.players:
		if i.score >= target_score:
			print("Player", i.player_name, "won with", i.score, "points!")
			break

func _physics_process(delta: float) -> void:
	camera_transition += delta * camera_speed
	camera_transition = min(camera_transition, 1.)
	if state == GameState.THROWING_START or state == GameState.THROWING:
		camera.transform = (camera_starting if first_throw else camera_target).transform.interpolate_with(camera_prethrow.transform, camera_transition)
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
		physics_timer.stop()
		var d1 = dice1.get_value()
		var d2 = dice2.get_value()
		if d1 != 1 and d2 != 1:
			ui.players[current_player].score += d1 + d2
		elif d1 == 1 and d2 == 1:
			ui.players[current_player].score = 0
		ui.update_medal()
		check_score()
		next_player()

	ui.set_current_throw_value([dice1.get_value(), dice2.get_value()])

func throw_dice() -> void:
	if dice1.can_be_thrown() and dice2.can_be_thrown():
		dice1.random_throw()
		dice2.random_throw()
		state = GameState.THROWING_START
		camera_transition = 0.
		physics_timer.start(physics_timeout)
