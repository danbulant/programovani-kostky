extends Control

@onready var selector: Control = $SelectorContainer
@onready var p1 = $Players/Player1
@onready var p2 = $Players/Player2
@onready var p3 = $Players/Player3
@onready var p4 = $Players/Player4
@onready var p5 = $Players/Player5
@onready var start_button: Button = $StartButton
@onready var start_disabled_info: Label = $StartDisabledInfo

var players: Array[VBoxContainer]
var player_names: Array[String] = ["", "", "", "", ""]
var player_ready := false
signal start_game
signal back_to_menu

var tween: Tween
func _ready() -> void:
	players = [p1, p2, p3, p4, p5]

	get_viewport().connect("gui_focus_changed", _on_focus_changed)
	for player in players:
		var line_edit: LineEdit = player.get_node("LineEdit")
		line_edit.connect("text_changed", _on_text_changed)

func recheck_names() -> void:
	var non_empty_player_names = 0
	for pname in player_names:
		if pname != "":
			non_empty_player_names += 1
	player_ready = non_empty_player_names >= 2
	start_disabled_info.visible = !player_ready
	start_button.disabled = !player_ready

func _on_start_button_pressed() -> void:
	start_game.emit()

func _on_focus_changed(focus: Control) -> void:
	if focus is LineEdit:
		var parent: VBoxContainer = focus.get_parent()
		if parent is VBoxContainer:
			selector.visible = true
			if tween:
				tween.kill()
			tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
			tween.tween_property(selector, "global_position:x", parent.global_position.x + parent.size.x/2 - selector.size.x/2, .6)
			return
	selector.visible = false

func _on_text_changed(_text: String) -> void:
	for i in players.size():
		player_names[i] = players[i].get_node("LineEdit").text
	recheck_names()

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event.is_pressed():
			back_to_menu.emit()
