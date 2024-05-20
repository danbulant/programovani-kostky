extends Node3D

# var select_scene = preload("res://player_select/player_select.tscn")

@onready var menu_ui = $MenuUi

signal start_game
@export var ui_visible := true :
	set(visible):
		ui_visible = visible
		menu_ui.visible = ui_visible
	
func _ready() -> void:
	menu_ui.visible = ui_visible

func _on_menu_ui_start_pressed() -> void:
	# get_tree().change_scene_to_packed(select_scene)
	start_game.emit()