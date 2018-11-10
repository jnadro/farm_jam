extends KinematicBody2D

export (int) var min_speed # Minimum speed range.
export (int) var max_speed # Maximum speed range.
export (int) var health
var player
var speed = 600
var velocity = Vector2()
var prev_pos

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	health = 40
	player = get_tree().get_nodes_in_group("player")[0]
	prev_pos = position

func _process(delta):
	var xMag = velocity.x * velocity.x
	var yMag = velocity.y * velocity.y

	if velocity.x > 0 and velocity.y == 0:
	    $AnimatedSprite.animation = "Right"
	elif velocity.y < 0 and velocity.x == 0:
	    $AnimatedSprite.animation = "Up"
	elif velocity.y > 0 and velocity.x == 0:
		$AnimatedSprite.animation = "Down"
	elif velocity.y == 0 and velocity.x < 0:
		$AnimatedSprite.animation = "Left"
	elif velocity.y > 0 and velocity.x > 0:
		if xMag < yMag:
			$AnimatedSprite.animation = "Down"
		else:
			$AnimatedSprite.animation = "Right"
	elif velocity.y < 0 and velocity.x > 0:
		if xMag < yMag:
			$AnimatedSprite.animation = "Up"
		else:
			$AnimatedSprite.animation = "Right"
	elif velocity.y < 0 and velocity.x < 0:
		if xMag < yMag:
			$AnimatedSprite.animation = "Up"
		else:
			$AnimatedSprite.animation = "Left"
	elif velocity.y > 0 and velocity.x < 0:
		if xMag < yMag:
			$AnimatedSprite.animation = "Down"
		else:
			$AnimatedSprite.animation = "Left"

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
	health -= dmg
	if health <= 0:
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
	
