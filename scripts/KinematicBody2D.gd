extends KinematicBody2D

var player
var speed = 600
var velocity = Vector2()
var prev_pos
var parent

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	player = get_tree().get_nodes_in_group("player")[0]
	prev_pos = position
	parent = get_parent()
	sprite = get_children('AnimatedSprite')

func _process(delta):
	var xMag = velocity.x * velocity.x
	var yMag = velocity.y * velocity.y

	if velocity.x > 0 and velocity.y == 0:
	    sprite.animation = "Right"
	elif velocity.y < 0 and velocity.x == 0:
	    sprite.animation = "Up"
	elif velocity.y > 0 and velocity.x == 0:
		sprite.animation = "Down"
	elif velocity.y == 0 and velocity.x < 0:
		sprite.animation = "Left"
	elif velocity.y > 0 and velocity.x > 0:
		if xMag < yMag:
			sprite.animation = "Down"
		else:
			sprite.animation = "Right"
	elif velocity.y < 0 and velocity.x > 0:
		if xMag < yMag:
			sprite.animation = "Up"
		else:
			sprite.animation = "Right"
	elif velocity.y < 0 and velocity.x < 0:
		if xMag < yMag:
			sprite.animation = "Up"
		else:
			sprite.animation = "Left"
	elif velocity.y > 0 and velocity.x < 0:
		if xMag < yMag:
			sprite.animation = "Down"
		else:
			sprite.animation = "Left"

# Update position to follow player
func _physics_process(delta):

	var direction = (player.position - position).normalized() * speed
	move_and_slide(direction * delta)
	velocity = position - prev_pos
	prev_pos = position
	
# Delete themselves when they leave the screen
func _on_Visibility_screen_exited():
    queue_free()

func damage(dmg):
	parent.health -= dmg
	if parent.health <= 0:
		die()
	else:
		if $BloodParticles.emitting == false:
			$BloodParticles.emitting = true
		pass

func knock_back(pos):
	# Update position
	var direction = (position - pos).normalized()
	move_and_slide(direction * 400)
	
func die():
	# Emit particles of blood
	# Hide
	hide()
	# Disable collision detection
	$CollisionShape2D.disabled = true
	
