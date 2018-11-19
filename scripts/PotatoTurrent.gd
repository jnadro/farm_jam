extends Area2D

# class member variables go here, for example:
var ammo = 1
var active = false
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
	
func _on_reload_completed():
	ammo += GameState.empty_crop_inventory("Potato")
	stop_progress()
	
func start_progress():
	$ProgressBar.visible = true
	$ProgressBar.start(ammo_reload_time * GameState.get_crop_count_in_inventory("Potato"))
	$ProgressBar.connect("progress_completed", self, "_on_reload_completed")
	play_load_ammo_animation()
	$ReloadSound.play()
	
func stop_progress():
	$ProgressBar.visible = false
	$ProgressBar.stop()
	stop_load_ammo_animation()
	$ReloadSound.stop()
	
func _process(delta):
	if player_nearby:
		if !active && Input.is_action_pressed("interact") && GameState.has_crop_in_inventory("Potato"):
			start_progress()
			active = true
		elif active && Input.is_action_just_released("interact"):
			stop_progress()
			active = false
			
	$AmmoCount.text = str(ammo)

func _on_PotatoTurrent_area_entered(area):
	if area.is_in_group("Player"):
		player_nearby = true

func _on_PotatoTurrent_area_exited(area):
	if area.is_in_group("Player"):
		player_nearby = false
		active = false
		stop_progress()

func _on_FireCooldown_timeout():
	if ammo > 0:
		var mob = get_node("/root/Game/Chicken") # super hacky
		if mob != null:
			var bullet = bullet_scene.instance()
			var to_mob = mob.get_global_position() - get_global_position()
			bullet.dir = to_mob.normalized()
			add_child(bullet)
			ammo -= 1
			$FireSound.play()



