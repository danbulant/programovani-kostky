extends Control

@onready var player1 = $VBoxContainer/Player
@onready var player2 = $VBoxContainer/Player2
@onready var player3 = $VBoxContainer/Player3
@onready var player4 = $VBoxContainer/Player4
@onready var player5 = $VBoxContainer/Player5
@onready var title = $Title
@onready var container = $VBoxContainer

var players = []
signal new_game_requested
signal back_to_menu

func _ready() -> void:
	players = [
		player1,
		player2,
		player3,
		player4,
		player5
	]

func apply() -> void:
	players.sort_custom(func(a,b) -> int:
		return b.score - a.score
	)
	var max_score = -1
	var max_player = 0
	for i in players.size():
		if players[i].name == "":
			players[i].visible = false
			continue
		if players[i].score >= max_score:
			max_score = players[i].score
			max_player = i
		var next_player_num = i+1
		if next_player_num >= players.size(): break
		var next_player = players[next_player_num]
		while next_player.name == "":
			next_player_num += 1
			if next_player_num >= players.size(): break
			next_player = players[next_player_num]
		if not next_player: break
		players[i].score_change = "+" + str(players[i].score - next_player.score)
	players[players.size()-1].score_change = "+" + str(players[players.size()-1].score)
	for player in players:
		container.remove_child(player)
	for player in players:
		container.add_child(player)
	title.text = "%s won with %d points!" % [players[max_player].name, players[max_player].score]

func _on_newbtn_pressed() -> void:
	new_game_requested.emit()


func _on_exit_button_gui_input(event:InputEvent) -> void:
	if event is InputEventMouse:
		if event.is_pressed():
			back_to_menu.emit()
