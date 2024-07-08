extends Node2D

@onready var enemies: Array = get_children()
@onready var battle = get_parent()
@onready var battle_queue: Array
@onready var battle_indexes: Array
@onready var player_group = %PlayerGroup
@onready var players = player_group.players
@onready var player_count = players.size()
var attack_finished = false
var is_fighting = false
var index = 0
var sequences = 0
signal next_player_turn

#This positions enemies
func _ready():
	for i in enemies.size():
		enemies[i].position = Vector2(300, i*156+100)
	choose_enemy()

func _process(delta):
	#This happens when the player clicks on fight
	if battle_queue.size() == enemies.size():
		print("doner")
		for i in range(battle_queue.size()):
			#battle_queue[i].call(battle_indexes[i])
			print("pop")
			await get_tree().create_timer(3).timeout
			
		battle_queue.clear()
		print("done")
		reset_choice()
		emit_signal("next_player_turn")
			
	
	if battle.chose_fight == true:
		fight()


func show_arrow(x, y):
	enemies[x].choose()
	enemies[y].unchoose()
	
func attack_queue(i):
	#enemies will take damage then it will confirm attack is done 
	#then after 0.5 seconds the enemy will attack 
	#the steps above are reverted and then it resets
	enemies[i].take_damage(10)
	attack_finished = true
	await get_tree().create_timer(0.5).timeout
	attack_player(i)
	battle.chose_fight = false
	attack_finished = false
	
func choose_enemy():
	enemies[0].choose()
	
func reset_choice():
	#index is resetted and those that aren't the first enemy get unselected
	index = 0
	for enemy in enemies:
		enemy.unchoose()
	choose_enemy()
	battle.v_box_container.visible = false
	print(battle_indexes)
		
func attack_player(i):
	#a random player is chosen via the index and a random enemy's damage is used
	print(i)
	players[randi_range(0, player_count-1)].take_damage(enemies[randi_range(0, index-1)].damage)

func _on_defend_pressed():
	#similar function to attack_queue() but no harm is done to the enemies
	battle_queue.append(Callable(self, "attack_player"))
	battle_indexes.push_back(index) #to help make actions go in order
	emit_signal("next_player_turn")

func fight():
	#this section of code lets you select an enemy
	if Input.is_action_just_pressed("ui_up"):
		if index > 0:
			index -= 1
			show_arrow(index, index+1)
		
	if Input.is_action_just_pressed("ui_down"):
		if index < enemies.size() - 1:
			index += 1
			show_arrow(index, index-1)
		
	#starts the attack queue function and the second condition prevents double attacking
	if Input.is_action_just_pressed("ui_accept") and attack_finished == false:
		battle_indexes.push_back(index) #to help make actions go in order
		battle_queue.append(Callable(self, "attack_queue"))
		attack_finished = true
		battle.chose_fight = false
		attack_finished = false
		reset_choice()
		emit_signal("next_player_turn")

#to keep track of turn/move queue
func _on_player_group_make_choice():
	pass
