extends Area2D
signal hit

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
# If the player press a directionel arrow, then its position change
func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed # Prevents diagonal movements ?
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	# Updates the player position
	position += velocity * delta
	# Prevents the player from overtaking the screen
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Animation "walk" if the player moves horizontally
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		# Same as $AnimatedSprite.flip_v = velocity.x > 0
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	# Animation "up" if the player moves vertically
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"


func _on_Player_body_entered(body):
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	# Disables the collision
	$CollisionShape2D.set_deferred("disabled", true)


# Reinitialise the player at the beginning of the game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
