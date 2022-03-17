extends Node2D

class_name TurnQueue

var active_player:Player
var playerCount
var players
var turn
signal end_of_turn
signal end_of_mg

func _ready():
	Net.set_ids()
	create_players()
	players = get_children()
	playerCount = players.size()
	if Net.is_host:
		active_player=players[0]
		turn = 0
	else:
		active_player=players[1]
		turn = 1
	play_turn()
	
func create_players():
	for id in Net.peer_ids:
		create_player(id)
	create_player(Net.net_id)

func create_player(id):
	#print("Player with ID " + str(id) + " initialized")
	var p = preload("res://src/Map/Player.tscn").instance()
	add_child(p)
	p.initialize(id)
	var vec = Vector2()
	vec.x = 1183
	vec.y = 2138
	p.set_position(vec)

func play_turn():
	active_player.get_node("Camera").make_current()
	if active_player.is_master:
		yield(active_player.play_turn(),"completed")
	else:
		yield(active_player,"completed")
	#rpc_unreliable("active_player_play")
	if turn<playerCount-1:
		turn=turn+1
	else:
		turn=0
		emit_signal("end_of_turn")
		yield(get_parent(),"end_of_mg")
		

	active_player=players[turn]
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	#rpc_unreliable("change_player", active_player)
	play_turn()


remotesync func active_player_play():
	yield(active_player.play_turn(),"completed")
	
remotesync func change_player(act):
	active_player=act
