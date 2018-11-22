extends KinematicBody2D

# class member variables go here, for example:
export(float) var damage = 40.0
var dir = Vector2()
var vel = 300

const explosion_scene = preload( "res://scenes/Explosion.tscn" )
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
			var explosion = explosion_scene.instance()
			explosion.global_position = collider.global_position
			collider.get_parent().add_child( explosion )
			collider.damage(damage)
			queue_free()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

# when we leave the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
