extends Node3D

var main_scene = preload("res://game/main.tscn")

func _on_menu_ui_start_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)
