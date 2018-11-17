extends Area2D

# class member variables go here, for example:
var ammo = 1
var active = false
var player_nearby = false
var ammo_reload_time = 1.0

const bullet_scene = preload( "res://scenes/Bullet.tscn" )

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func _on_reload_completed():
	ammo += GameState.empty_crop_inventory("Potato")
	
func start_progress():
	$ProgressBar.visible = true
	$ProgressBar.start(ammo_reload_time)
	$ProgressBar.connect("progress_completed", self, "_on_reload_completed")
	
func stop_progress():
	$ProgressBar.visible = false
	$ProgressBar.stop()
	
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
		var mob = get_node("/root/Game/Mob") # super hacky
		if mob != null:
			var bullet = bullet_scene.instance()
			var to_mob = mob.get_global_position() - get_global_position()
			bullet.dir = to_mob.normalized()
			add_child(bullet)
			ammo -= 1



