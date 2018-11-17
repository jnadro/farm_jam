extends Area2D

# class member variables go here, for example:
var ammo = 0
var active = false
var player_nearby = false
var ammo_reload_time = 1.0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func start_progress():
	$ProgressBar.visible = true
	$ProgressBar.start(ammo_reload_time)
	# progress_bar.connect("progress_completed", self, callback)
	
func stop_progress():
	$ProgressBar.visible = false
	$ProgressBar.stop()	

func _process(delta):
	if player_nearby:
		if !active && Input.is_action_pressed("interact"):
			start_progress()
			active = true
		elif active && Input.is_action_just_released("interact"):
			stop_progress()
			active = false

func _on_PotatoTurrent_area_entered(area):
	if area.is_in_group("Player"):
		player_nearby = true

func _on_PotatoTurrent_area_exited(area):
	if area.is_in_group("Player"):
		player_nearby = false
		active = false
		stop_progress()

func _on_FireCooldown_timeout():
	pass



