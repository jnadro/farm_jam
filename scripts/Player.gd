extends Area2D
signal player_took_damage

# Member variables
export (int) var speed
var screensize
var can_attack = true
var can_taunt = true
var damage = 10
var hitbox_lookup
var health = 100
var direction

# Called once
func _ready():
	screensize = get_viewport().size
	hitbox_lookup = {
		"Right": $HitboxRight,
		"Left": $HitboxLeft,
		"Up": $HitboxUp,
		"Down": $HitboxDown,
		"UpRight": $HitboxUpRight,
		"UpLeft": $HitboxUpLeft,
		"DownRight": $HitboxDownRight,
		"DownLeft": $HitboxDownLeft
	}
	direction = $AnimatedSprite.animation
	connect("player_took_damage", GameState, "_on_Player_player_took_damage")

# Called in update loop
func _process(delta):
	if is_alive() == false:
		return
		
	if Input.is_action_pressed("drop_bomb") and GameState.has_bomb() and can_player_taunt():
		can_taunt = false
		$TauntTimer.start()
		GameState.drop_taunt_bomb()
		
	# Do not let the player move while attacking
	if is_attacking() == false:
		# Determine player direction
		var velocity = Vector2()
		if Input.is_action_pressed('ui_right'):
			velocity.x += 1
		if Input.is_action_pressed('ui_left'):
			velocity.x -= 1
		if Input.is_action_pressed('ui_down'):
			velocity.y += 1
		if Input.is_action_pressed('ui_up'):
			velocity.y -= 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite.play()
		else:
			if is_attacking() == false:
				$AnimatedSprite.stop()
		
		# Update position
		position += velocity * delta
		
		# Prevent from leaving the screen
		position.x = clamp(position.x, 0, screensize.x)
		position.y = clamp(position.y, 0, screensize.y)
		
		# Get the direction the player is facing
		direction = get_facing_direction(velocity)
	
	if $AttackTimer.time_left == 0:
		$AnimatedSprite.animation = direction
	
	# Attacking
	if Input.is_action_pressed("mouse_left") and can_player_attack():
		can_attack = false
		# Only attack mobs facing your direction
		var hitbox = hitbox_lookup[direction]
		attack_mobs(hitbox.get_overlapping_bodies(), position)
		$AttackTimer.start()
		set_attack_animation(direction)
	
	update_shadow_sprite(direction)
		
func update_shadow_sprite (direction):
	if $ShadowSprite:
		$ShadowSprite.animation = direction
		
func attack_mobs(mobs, force):
	for mob in mobs:
		mob.damage(damage)
		mob.knock_back(force)
	
func can_player_attack ():
	return can_attack && is_alive()
	
func can_player_taunt():
	return can_taunt && is_alive()
	
func is_alive():
	return health > 0

func is_attacking():
	return $AttackTimer.time_left > 0

func get_attack_animation (facing):
	return "Attack_" + facing
	
func set_attack_animation (facing):
	var animation  = get_attack_animation(facing)
	$AnimatedSprite.animation  = animation
	$AnimatedSprite.play()
	
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
			
	return direction;

func damage(dmg):
	health -= dmg
	emit_signal("player_took_damage")
	if health <= 0:
		die()
	else:
		if $BloodParticles.emitting == false:
			$BloodParticles.emitting = true
		pass
		
func die():
	# Emit particles of blood
	# Hide
	$AnimatedSprite.animation = "Death"
	$AnimatedSprite.play()
	#hide()
	# Disable collision detection
	#$CollisionShape2D.disabled = true

func _on_Player_body_entered(body):
	pass
	#print("HIT")
	#hide() # Player disappears after being hit.
	#$CollisionShape2D.disabled = true

func _on_AttackTimer_timeout():
	can_attack = true


func _on_TauntTimer_timeout():
	can_taunt = true
