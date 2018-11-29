extends KinematicBody2D

signal die(mob)

enum STATES { SPAWNING, TAUNTED, HUNT }

export (int) var min_speed # Minimum speed range.
export (int) var max_speed # Maximum speed range.
export (int) var health

var player
var speed = 5000
var velocity = Vector2()
var prev_pos
var hue_timer = 0
var colorDecaySpeed = 60
var state = STATES.HUNT
var target = null

func _ready():
	# Called when the node is added to the scene for the first time.
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
	var target_position = player.get_global_position()
	if state == STATES.TAUNTED and target:
		target_position = target.get_global_position()
	var direction = (target_position - get_global_position()).normalized() * currentSpeed
	move_and_slide(direction * delta)
	velocity = get_global_position() - prev_pos
	prev_pos = get_global_position()
	
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
	#if $ShadowSprite:
	#	$ShadowSprite.animation = direction
	pass

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
	# Remove from memory
	queue_free()
	# Let others know a mob died
	emit_signal("die", self)
	
func _on_AttackTimer_timeout():
	if position.distance_to(player.position) <= 32:
		player.damage(10)

func taunt(in_target):
	state = STATES.TAUNTED
	target = in_target
	$TauntIndicator.visible = true
	$TauntSound.play()
		
func _on_taunt_timeout():
	state = STATES.HUNT
	target = null
	$TauntIndicator.visible = false	

