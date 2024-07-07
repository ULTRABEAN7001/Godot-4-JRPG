extends Node2D

@onready var players: Array = get_children()
var index = 0
var player_turn = true
signal make_choice
@onready var chosen_player = players[index]


func _ready():
	for i in players.size():
		players[i].position = Vector2(819, i*156+150)
	reset_choice()

func _process(delta):
	
	if player_turn == true:
		if Input.is_action_just_pressed("ui_up"):
			if index > 0:
				index -= 1
				show_choice(index, index+1)
		
		if Input.is_action_just_pressed("ui_down"):
			if index < players.size() - 1:
				index += 1
				show_choice(index, index-1)
			
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("make_choice")
			print(chosen_player)
			player_turn = false
			match index:
				0:
					print("brown owl")
				1:
					print("white owl")
				2:
					print("grey owl")
				3:
					print("JEREMY")

func show_choice(x, y):
	players[x].choose()
	players[y].unchoose()

func reset_choice():
	index = 0
	for i in players:
		i.unchoose()
		i.is_protected = false
	players[0].choose()
	
func _on_enemy_group_next_player_turn():
	player_turn = true
	reset_choice()


func _on_defend_pressed():
	players[index].is_protected = true
