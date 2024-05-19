extends Control

@export var value := 1 :
	set(_value):
		value = _value
		queue_redraw()

@export var color := Color(1, 1, 1) :
	set(_color):
		color = _color
		queue_redraw()

@export var bg_color := Color(0, 0, 0) :
	set(_bg_color):
		bg_color = _bg_color
		stylebox.bg_color = bg_color
		queue_redraw()

func _get_minimum_size() -> Vector2:
	return Vector2(30, 30)

var stylebox = StyleBoxFlat.new()

func _ready() -> void:
	stylebox.bg_color = bg_color
	var radius := 5
	stylebox.corner_radius_bottom_left = radius
	stylebox.corner_radius_bottom_right = radius
	stylebox.corner_radius_top_left = radius
	stylebox.corner_radius_top_right = radius

func _draw() -> void:
	var dim = min(size.x, size.y)

	draw_style_box(stylebox, Rect2(Vector2(), size))

	var point_size = dim / 10
	var center = Vector2(dim / 2, dim / 2)
	var topleft = Vector2(dim / 4, dim / 4)
	var topright = topleft + Vector2(dim / 2, 0)
	var bottomleft = topleft + Vector2(0, dim / 2)
	var bottomright = topleft + Vector2(dim / 2, dim / 2)
	var centerleft = topleft + Vector2(0, dim / 4)
	var centerright = topleft + Vector2(dim / 2, dim / 4)
	var centertop = topleft + Vector2(dim / 4, 0)
	var centerbottom = topleft + Vector2(dim / 4, dim / 2)

	if value % 2 == 1:
		draw_circle(center, point_size, color)

	if value >= 2:
		draw_circle(topleft, point_size, color)
		draw_circle(bottomright, point_size, color) 

	if value >= 4:
		draw_circle(topright, point_size, color)
		draw_circle(bottomleft, point_size, color)

	if value >= 6:
		draw_circle(centerleft, point_size, color)
		draw_circle(centerright, point_size, color)

	if value >= 8:
		draw_circle(centertop, point_size, color)
		draw_circle(centerbottom, point_size, color)

	pass