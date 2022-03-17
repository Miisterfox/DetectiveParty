extends TileMap

enum {BASIC,SPECIAL,SPAWN,EMPTY=-1}

		
func start_game():
	print("map/start")
	self.visible = true
