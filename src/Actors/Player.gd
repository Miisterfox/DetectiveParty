extends Area2D

class_name Player
onready var Grid = get_parent().get_parent() #Schnaps

var is_master = false
var motion = 0

signal completed
signal dice_rolled
signal move

var tile_size = 64
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN,}

var current_dir
var speed = 0
var velocity = Vector2()
const MAX_SPEED = 800

func _ready():
	current_dir = Vector2.UP
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	
func initialize(id):
	name = str(id)
	if id == Net.net_id:
		is_master = true
	else:
		modulate = Color8(255, 0, 0, 255)
		
			
	
func play_turn():
	var D = self.get_node("Dice")
	D.show()
	yield(D,"dice_rolled")
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var dice = rng.randf_range(1, 6)
	var num = int(dice)
	D.hide()
	for _i in range(dice):
		update_dice(num - _i)
		var target_position = Grid.request_move(self,current_dir)
		if target_position:
			var t = Timer.new()
			t.set_wait_time(0.2)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			var possible_dir = change_dir(current_dir)
			if(possible_dir.size()==1):
				current_dir = possible_dir[0]
			else:
				for dir in change_dir(current_dir):
					if(dir == Vector2.RIGHT):
						get_node("RIGHT").show()
					if(dir == Vector2.LEFT):
						get_node("LEFT").show()
					if(dir == Vector2.DOWN):
						get_node("DOWN").show()
					if(dir == Vector2.UP):
						get_node("UP").show()
						
				yield(self,"move")
				for dir in change_dir(current_dir):
					get_node("RIGHT").hide()
					get_node("LEFT").hide()
					get_node("DOWN").hide()
					get_node("UP").hide()
			move()
		else:
			var t = Timer.new()
			t.set_wait_time(0.2)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			var possible_dir = change_dir(current_dir)
			if(possible_dir.size()==1):
				current_dir = possible_dir[0]
			else:
				for dir in change_dir(current_dir):
					if(dir == Vector2.RIGHT):
						get_node("RIGHT").show()
					if(dir == Vector2.LEFT):
						get_node("LEFT").show()
					if(dir == Vector2.DOWN):
						get_node("DOWN").show()
					if(dir == Vector2.UP):
						get_node("UP").show()
						
				yield(self,"move")
			for dir in change_dir(current_dir):
				get_node("RIGHT").hide()
				get_node("LEFT").hide()
				get_node("DOWN").hide()
				get_node("UP").hide()
			move()
		update_dice(0)
	emit_signal("completed")
	rpc_unreliable("end_turn")
		
func move():
	position += current_dir * tile_size
	rpc_unreliable("set_pos_and_motion", position)
	
# Synchronize position and speed to the other peers.
remotesync func set_pos_and_motion(p_pos):
	position = p_pos
	
remotesync func end_turn():
	emit_signal("completed")

func change_dir(dir):
	var possible_mov = []
	if(Grid.request_move(self,Vector2.UP) && dir!=Vector2.DOWN):
		possible_mov.append(Vector2.UP)
	if(Grid.request_move(self,Vector2.RIGHT) && dir!=Vector2.LEFT):
		possible_mov.append(Vector2.RIGHT)
	if(Grid.request_move(self,Vector2.DOWN) && dir!=Vector2.UP):
		possible_mov.append(Vector2.DOWN)
	if(Grid.request_move(self,Vector2.LEFT) && dir!=Vector2.RIGHT):
		possible_mov.append(Vector2.LEFT)
	return possible_mov

func update_dice(numb):
	if(numb == 0):
		$Camera/Label.text = ""
	else :
		$Camera/Label.text = str(numb)



func _on_LEFT_pressed():
	current_dir = Vector2.LEFT
	emit_signal("move")


func _on_RIGHT_pressed():
	current_dir = Vector2.RIGHT
	emit_signal("move")


func _on_DOWN_pressed():
	current_dir = Vector2.DOWN
	emit_signal("move")
	

func _on_UP_pressed():
	current_dir = Vector2.UP
	emit_signal("move")
