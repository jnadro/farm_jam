extends KinematicBody2D

# class member variables go here, for example:
var dir = Vector2()
var vel = 300

const mob = preload("res://scripts/Mob.gd")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func _physics_process( delta ):
	var collision = move_and_collide( vel * dir * delta )
	if collision != null:
		var collider = collision.get_collider()
		if collider is mob:
			queue_free()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

# when we leave the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
