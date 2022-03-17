extends TileMap

enum {BASIC,GARDEN,CHEF,INFO,EMPTY=-1}
var Labyrinthe = preload("res://src/Labyrinthe/src/Map/Labyrinthe.tscn")
var Cloud = preload("res://src/MiniGames/Main.tscn")
var game_chosen = false
var game

signal f
signal end_of_mg

func ready():
	for child in get_children():
		set_cellv(world_to_map(child.position),child.type)
			
func request_move(tile,direction):
	var cell_start = world_to_map(tile.position)
	var cell_target = cell_start + direction
	
	var targetCell_tile_id = get_cellv(cell_target)
	
	#Attention inversion Basic/Special
	match targetCell_tile_id:
		EMPTY:
			return false
		BASIC:
			return true
		GARDEN:
			if(!game_chosen):
				select_labyrinthe()
				rpc("select_labyrinthe")
			return true
		CHEF:
			if(!game_chosen):
				select_cloud()
				rpc("select_cloud")
			return true
		INFO:
			return true
		
		
func set_dice_process(boolean):
	for c in get_child(0).get_children():
		if c.is_class("Area2D"):
			c.get_child(3).set_process_unhandled_input(boolean)
				
				
remotesync func launch_game():
	var game_instance = game.instance()
	get_parent().add_child(game_instance)
	self.hide()
	set_dice_process(false)
	yield(game_instance,"f")
	set_dice_process(true)
	game_instance.queue_free()
	game_chosen = false
	rpc("emit_end_of_mg")
	self.show()

remotesync func select_labyrinthe():
	game_chosen=true
	game=Labyrinthe

remotesync func select_cloud():
	game_chosen=true
	game=Cloud

remotesync func emit_end_of_mg():
	emit_signal("end_of_mg")

func _on_TurnQueue_end_of_turn():
	print("oui?")
	var t = Timer.new()
	t.set_wait_time(0.2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	if(!game_chosen):emit_signal("end_of_mg")
	else:
		rpc("launch_game")
		launch_game()
