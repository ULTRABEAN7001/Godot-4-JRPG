extends Node2D

var chose_fight = false
@onready var v_box_container = $CanvasLayer/VBoxContainer
@onready var player_group = %PlayerGroup
var actions: Array

func _ready():
	v_box_container.visible = false

func _on_fight_pressed():
	v_box_container.visible = false
	chose_fight = true
	player_group.player_turn = false

func _on_player_group_make_choice():
	v_box_container.visible = true

func _on_defend_pressed():
	v_box_container.visible = false
