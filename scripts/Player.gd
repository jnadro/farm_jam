extends Area2D
signal hit

# Member variables
export (int) var speed
var screensize
var can_attack = true
var damage = 10
var hitbox_lookup

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
	pass

# Called in update loop
func _process(delta):
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
		$AnimatedSprite.stop()
	
	# Update position
	position += velocity * delta
	
	# Prevent from leaving the screen
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	# Get the direction the player is facing
	var direction = get_facing_direction(velocity)
	$AnimatedSprite.animation = direction
		
	# Attacking
	if Input.is_action_pressed("mouse_left") and can_attack:
		can_attack = false
		# Only attack mobs facing your direction
		var hitbox = hitbox_lookup[direction]
		attack_mobs(hitbox.get_overlapping_bodies(), position)
		$AttackTimer.start()
		
func attack_mobs(mobs, force):
	for mob in mobs:
		mob.damage(damage)
		mob.knock_back(force)
	
func get_facing_direction(velocity):
	if velocity.x > 0 and velocity.y == 0:
	    return "Right"
	elif velocity.y < 0 and velocity.x == 0:
	    return "Up"
	elif velocity.y > 0 and velocity.x == 0:
		return "Down"
	elif velocity.y == 0 and velocity.x < 0:
		return "Left"
	elif velocity.y > 0 and velocity.x > 0:
		return "DownRight"
	elif velocity.y < 0 and velocity.x > 0:
		return "UpRight"
	elif velocity.y < 0 and velocity.x < 0:
		return "UpLeft"
	elif velocity.y > 0 and velocity.x < 0:
		return "DownLeft"
	return $AnimatedSprite.animation;

func _on_Player_body_entered(body):
	#print("HIT")
	#hide() # Player disappears after being hit.
	emit_signal("hit")
	#$CollisionShape2D.disabled = true

func _on_AttackTimer_timeout():
	can_attack = true
