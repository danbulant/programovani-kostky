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

@onready var player1 = $VBoxContainer/Player
@onready var player2 = $VBoxContainer/Player2
@onready var player3 = $VBoxContainer/Player3
@onready var player4 = $VBoxContainer/Player4
@onready var player5 = $VBoxContainer/Player5
@onready var container = $VBoxContainer
@onready var pointer = $CurrentPlayerPointer

var players: Array[Player] = []
var current_player: int = 0 :
	set(value):
		current_player = value
		update_pointer()

var tween: Tween
func _ready() -> void:
	players = [player1, player2, player3, player4, player5]

func update_pointer() -> void:
	pointer.global_position.x = container.size.x
	var p = players[current_player]
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(pointer, "global_position:y", p.global_position.y + p.size.y/2 - pointer.size.y/2, .6)

func update_medal() -> void:
	var max_score = 0
	for player in players:
		if player.score > max_score:
			max_score = player.score
	for player in players:
		player.show_medal = player.score == max_score and max_score > 0

signal back_to_menu
func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event.is_pressed():
			back_to_menu.emit()