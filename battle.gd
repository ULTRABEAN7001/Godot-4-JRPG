extends Node2D

var chose_fight = false
@onready var v_box_container = $CanvasLayer/VBoxContainer
@onready var player_group = %PlayerGroup
var actions: Array

#This is here to make sure you select a player first
func _ready():
	v_box_container.visible = false
	print("We're on Github Now!")

#Activates functions to let you select who you want to fight
func _on_fight_pressed():
	v_box_container.visible = false
	chose_fight = true
	player_group.player_turn = false

#happens when a player is slected
func _on_player_group_make_choice():
	v_box_container.visible = true

#same as on_fight_pressed but only disables butttons
func _on_defend_pressed():
	v_box_container.visible = false
