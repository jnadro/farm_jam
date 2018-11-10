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
	var facing_direction = get_facing_direction(velocity)
	$AnimatedSprite.animation = facing_direction
	update_shadow_sprite(facing_direction)

# Update position to follow player
func _physics_process(delta):
	var currentSpeed = minimum_distance_to_player()
	var direction = (player.position - position).normalized() * currentSpeed
	move_and_slide(direction * delta)
	velocity = position - prev_pos
	prev_pos = position
	
# Delete themselves when they leave the screen
func _on_Visibility_screen_exited():
    queue_free()

func get_facing_direction(velocity):
	var xMag = velocity.x * velocity.x
	var yMag = velocity.y * velocity.y
	
	if velocity.x > 0 and velocity.y == 0:
		return "Right"
	elif velocity.y < 0 and velocity.x == 0:
		return "Up"
	elif velocity.y > 0 and velocity.x == 0:
		return "Down"
	elif velocity.y == 0 and velocity.x < 0:
		return "Left"
	elif velocity.y > 0 and velocity.x > 0:
		if xMag < yMag:
			return "Down"
		else:
			return "Right"
	elif velocity.y < 0 and velocity.x > 0:
		if xMag < yMag:
			return "Up"
		else:
			return "Right"
	elif velocity.y < 0 and velocity.x < 0:
		if xMag < yMag:
			return "Up"
		else:
			return "Left"
	elif velocity.y > 0 and velocity.x < 0:
		if xMag < yMag:
			return "Down"
		else:
			return "Left"
			
	return $AnimatedSprite.animation;
	
func update_shadow_sprite (direction):
	if $ShadowSprite:
		$ShadowSprite.animation = direction

func minimum_distance_to_player():
	if position.distance_to(player.position) <= 32:
		return 0;
	else:
		return speed

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
	
