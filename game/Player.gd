extends HBoxContainer

class_name Player

@onready var label: Label = $VBoxContainer/Label
@onready var medal: TextureRect = $TextureRect/Medal
@onready var dice1: DiceUi = $VBoxContainer/HBoxContainer/dice1
@onready var dice2: DiceUi = $VBoxContainer/HBoxContainer/dice2
@onready var dice3: DiceUi = $VBoxContainer/HBoxContainer/dice3
@onready var score_change_label: Label = $VBoxContainer/ScoreChange

@export var player_name: String :
	set(value):
		player_name = value
		visible = player_name != ""
		label.text = player_name

@export var show_medal: bool = false :
	set(value):
		show_medal = value
		medal.visible = show_medal

@export var score: int = 0 :
	set(value):
		score = value
		dice1.value = score / 100
		dice2.value = (score % 100) / 10
		dice3.value = score % 10

@export var score_change: String = "" :
	set(value):
		score_change = value
		score_change_label.text = score_change

func _ready():
	player_name = player_name
	show_medal = show_medal
	score = score
	score_change = score_change