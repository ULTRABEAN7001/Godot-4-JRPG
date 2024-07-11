extends CharacterBody2D

@export var health: = 100:
	set(value):
		health = value
		health_bar.value = value
@export var damage: = 10
@onready var health_bar = $HealthBar
@onready var pointer = $Pointer
@onready var animation_player = $AnimationPlayer
var is_protected = false


func _ready():
	health_bar.value = health
func choose():
	pointer.visible = true
func unchoose():
	pointer.visible = false
	
func take_damage(d):
	if is_protected == false:
		health -= d
		animation_player.play("hurt")
	if is_protected == true:
		animation_player.play("defended")
		
func defend():
	is_protected = true	
	
func undefend():
	is_protected = false
	
