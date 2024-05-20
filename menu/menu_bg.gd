extends Node3D

@onready var menu_ui = $MenuUi

signal start_game
@export var ui_visible := true :
	set(visible):
		ui_visible = visible
		menu_ui.visible = ui_visible
	
func _ready() -> void:
	menu_ui.visible = ui_visible

func _on_menu_ui_start_pressed() -> void:
	start_game.emit()