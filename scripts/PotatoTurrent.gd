extends Area2D

# class member variables go here, for example:
var ammo = 1
var reloading = false
var active_target = null
var player_nearby = false
var ammo_reload_time = 1.0

const bullet_scene = preload( "res://scenes/Bullet.tscn" )

func play_load_ammo_animation():
	$BounceX.interpolate_property($Sprite,
            'scale:y', 1, 1.25,
            1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	$BounceX.start()
	
	$BounceY.interpolate_property($Sprite,
            'scale:x', 1, 1.125,
            1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	$BounceY.start()
	
func stop_load_ammo_animation():
	$BounceX.stop_all()
	$BounceY.stop_all()
	# snap back to original scale
	$Sprite.scale.x = 1.0
	$Sprite.scale.y = 1.0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func start_progress():
	$ProgressBar.visible = true
	$ProgressBar.start(ammo_reload_time * GameState.get_crop_count_in_inventory("Potato"))
	play_load_ammo_animation()
	$AddAmmo.start()
	$ReloadSound.play()
	
func stop_progress():
	$ProgressBar.visible = false
	$ProgressBar.stop()
	stop_load_ammo_animation()
	$AddAmmo.stop()
	$ReloadSound.stop()
	
func _process(delta):
	if player_nearby:
		if !reloading && Input.is_action_pressed("interact") && GameState.has_crop_in_inventory("Potato"):
			start_progress()
			reloading = true
		elif reloading && Input.is_action_just_released("interact"):
			stop_progress()
			reloading = false
			
	$AmmoCount.text = str(ammo)

func _on_PotatoTurrent_area_entered(area):
	if area is preload("res://scripts/Player.gd"):
		player_nearby = true

func _on_PotatoTurrent_area_exited(area):
	if area is preload("res://scripts/Player.gd"):
		player_nearby = false
		reloading = false
		stop_progress()

func _on_FireCooldown_timeout():
	if ammo > 0 and !reloading:
		if active_target != null:
			var bullet = bullet_scene.instance()
			var to_mob = active_target.get_global_position() - get_global_position()
			bullet.dir = to_mob.normalized()
			add_child(bullet)
			ammo -= 1
			$FireSound.play()
			active_target = null

func _on_Range_body_entered(body):
	if body.is_in_group("mobs"):
		active_target = body
		print(active_target)

func _on_Range_body_exited(body):
	# lose the target if it leaves our area
	if active_target == body:
		active_target = null


func _on_ReloadSound_finished():
	# If we are still reloading, play the sound again.
	if reloading:
		$ReloadSound.play()


func _on_ProgressBar_progress_completed():
	ammo += GameState.empty_crop_inventory("Potato")
	stop_progress()


func _on_AddAmmo_timeout():
	var ammo_count = 1
	GameState.remove_crop_to_inventory("Potato", ammo_count)
	ammo += 1
