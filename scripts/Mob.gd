extends KinematicBody2D

export (int) var min_speed # Minimum speed range.
export (int) var max_speed # Maximum speed range.
export (int) var health

var player
var speed = 1000
var velocity = Vector2()
var prev_pos
var hue_timer = 0
var colorDecaySpeed = 60

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	health = 40
	player = get_tree().get_nodes_in_group("player")[0]
	prev_pos = position

func _process(delta):
	
	if $DisplayDamageTimer.time_left > 0:
		colorSpriteFromDamageTaken(delta)
	
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
		if $AttackTimer.is_stopped():
			$AttackTimer.start()
		return 0.5;
	else:
		return speed

func damage(dmg):
	health -= dmg

	#$HurtSample.play()
	if health <= 0:
		die()
	else:
		displayDamageTaken()

func knock_back(pos):
	# Update position
	var direction = (position - pos).normalized()
	move_and_slide(direction * 400)

func displayDamageTaken ():
	# Emit pixel blood particles
	if $BloodParticles.emitting == false:
		$BloodParticles.emitting = true
	
	# Turn red
	$DisplayDamageTimer.start();
	setSpriteRed()
		
func setSpriteRed():
	$AnimatedSprite.modulate = Color(1,0,0,1)

func colorSpriteFromDamageTaken (delta):
	var currentGreen = $AnimatedSprite.modulate.g
	var currentBlue = $AnimatedSprite.modulate.g
	var new_color = Color()

	var newGreen = currentGreen + delta if currentGreen + delta < 1.0 else 1.0
	var newBlue = currentBlue + delta if currentBlue + delta < 1.0 else 1.0
	
	new_color.r = 1
	new_color.g = newGreen
	new_color.b = newBlue
	new_color.a = 1
	
	$AnimatedSprite.modulate = new_color

func _on_DisplayDamageTimer_timeout():
	# Turn the damage coloring off
	$AnimatedSprite.modulate = Color(1,1,1,1)

func die():
	# Emit particles of blood
	# Hide
	hide()
	# Disable collision detection
	$CollisionShape2D.disabled = true
	
func _on_AttackTimer_timeout():
	if position.distance_to(player.position) <= 32:
		player.damage(10)

