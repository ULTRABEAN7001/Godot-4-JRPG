extends Node2D

@onready var enemies: Array = get_children()
@onready var battle = get_parent()
@onready var battle_queue: Array
@onready var battle_index: Array
@onready var player_group = %PlayerGroup
@onready var players = player_group.players
@onready var player_count = players.size()
var is_fighting = false
var index = 0
var sequences = 0
signal next_player_turn
signal empty_queue

#This positions enemies
func _ready():
	for i in enemies.size():
		enemies[i].position = Vector2(300, i*156+100)
	choose_enemy()

func _process(delta):
	#This happens when the player clicks on fight
	if battle.chose_fight == true:
		fight()
	
	#Happens when all players have made a move	
	if battle_queue.size() == enemies.size():
		#uses functions per nummber of moves
		for f in range(enemies.size()): 
			#calls the first function
			battle_queue[0].call(battle_index[0])
			#the pops prevent repetition or overlooping
			battle_queue.pop_front()
			battle_index.pop_front()
			#a 1 second delay
			await get_tree().create_timer(1).timeout
		#prepares the arrays for the next cycle
		battle_queue.clear()
		battle_index.clear()
		reset_choice()
		emit_signal("next_player_turn")
		#lets player_group know to disable defenses
		emit_signal("empty_queue")
			

func show_arrow(x, y):
	enemies[x].choose()
	enemies[y].unchoose()
	
func attack_queue(i):
	#enemies will take damage then it will confirm attack is done 
	#then after 0.5 seconds the enemy will attack 
	#the steps above are reverted and then it resets
	enemies[i].take_damage(10)
	await get_tree().create_timer(0.5).timeout
	attack_player(i)
	battle.chose_fight = false
	reset_choice()
	emit_signal("next_player_turn")
	
func choose_enemy():
	enemies[0].choose()
	
func reset_choice():
	#index is resetted and those that aren't the first enemy get unselected
	index = 0
	print(battle_index)
	print(battle_queue)
	for enemy in enemies:
		enemy.unchoose()
	choose_enemy()
	battle.v_box_container.visible = false
		
func attack_player(i):
	print(i)
	#a random player is chosen via the index and a random enemy's damage is used
	players[randi_range(0, player_count-1)].take_damage(enemies[randi_range(0, index-1)].damage)

func _on_defend_pressed():
	#similar function to attack_queue() but no harm is done to the enemies
	battle_index.append(index)
	battle_queue.append(Callable(self, "attack_player"))
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
	if Input.is_action_just_pressed("ui_accept"):
		battle_index.append(index)
		battle_queue.append(Callable(self, "attack_queue"))
		battle.chose_fight = false
		reset_choice()
		emit_signal("next_player_turn")
		
		
		

#to keep track of turn/move queue
func _on_player_group_make_choice():
	sequences += 1
