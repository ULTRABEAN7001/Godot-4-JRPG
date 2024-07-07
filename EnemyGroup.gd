extends Node2D

@onready var enemies: Array = get_children()
@onready var battle = get_parent()
@onready var battle_queue: Array
@onready var player_group = %PlayerGroup
@onready var players = player_group.players
@onready var player_count = players.size()
var attack_finished = false
var is_fighting = false
var index = 0
var sequences = 0
signal next_player_turn

func _ready():
	for i in enemies.size():
		enemies[i].position = Vector2(300, i*156+100)
	choose_enemy()

func _process(delta):
	
	if battle.chose_fight == true:
		fight()

func show_arrow(x, y):
	enemies[x].choose()
	enemies[y].unchoose()
	
func attack_queue():
	enemies[index].take_damage(10)
	attack_finished = true
	await get_tree().create_timer(0.5).timeout
	attack_player()
	battle.chose_fight = false
	attack_finished = false
	reset_choice()
	emit_signal("next_player_turn")
	
func choose_enemy():
	enemies[0].choose()
	
func reset_choice():
	index = 0
	for enemy in enemies:
		enemy.unchoose()
	choose_enemy()
	battle.v_box_container.visible = false
		
func attack_player():
	players[randi_range(0, player_count-1)].take_damage(enemies[randi_range(0, index-1)].damage)

func _on_defend_pressed():
	attack_player()
	emit_signal("next_player_turn")

func fight():
	if Input.is_action_just_pressed("ui_up"):
		if index > 0:
			index -= 1
			show_arrow(index, index+1)
		
	if Input.is_action_just_pressed("ui_down"):
		if index < enemies.size() - 1:
			index += 1
			show_arrow(index, index-1)
		
	if Input.is_action_just_pressed("ui_accept") and attack_finished == false:
		attack_queue()
		emit_signal("next_player_turn")

func _on_player_group_make_choice():
	sequences += 1
