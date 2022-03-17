extends RigidBody2D


export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.


# Randomly choose an animation for the mob
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

# The mob delete itself when he quit the scene
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
