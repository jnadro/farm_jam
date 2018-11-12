extends Node2D

signal harvestable

# class member variables go here, for example:
onready var ProgressBar = preload("res://scenes/ProgressBar.tscn")
export(float) var growth_time = 1.0
var harvestable = false
var planted_position = null
var pressed = false
var player_nearby = false
var harvesting_time = 1.0
var progress_bar = null

func _ready():
	var sprite_frames = $AnimatedSprite.get_sprite_frames()
	var fps = sprite_frames.get_frame_count("Grow") / growth_time
	sprite_frames.set_animation_speed("Grow", fps )
	$AnimatedSprite.play()
	$GrowthTimer.wait_time = growth_time
	$GrowthTimer.start()
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	#if harvestable:
	#	print(position)
	pass
	
func stop_progress():
	remove_child(progress_bar)
	progress_bar = null
	
func _on_Crop_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if harvestable && player_nearby:
			if event.pressed:
				pressed = true
				progress_bar = ProgressBar.instance()
				add_child(progress_bar)
				progress_bar.start(harvesting_time)
				progress_bar.connect("progress_completed", self, "_harvesting_completed")
			elif !event.pressed and pressed:
				stop_progress()
				
func _harvesting_completed():
	stop_progress()
	# need to pickup crop and do something

func _on_GrowthTimer_timeout():
	harvestable = true
	planted_position = position
	emit_signal("harvestable")
	$WiggleTimer.start()
	
func _on_Crop_mouse_exited():
	if progress_bar:
		stop_progress()


func _on_Crop_area_entered(area):
	if area.is_in_group("Player") and harvestable:
		$Highlight.show()		
		player_nearby = true


func _on_Crop_area_exited(area):
	if area.is_in_group("Player") and harvestable:
		$Highlight.hide()
		player_nearby = false
		if progress_bar:
			stop_progress()


func _on_WiggleTimer_timeout():
	var s = Vector2(randf() * 2.0, 0)
	var d = Vector2(randf() * 2.0, 0)
	var wiggle_duration = randf() * 2.0
	position = planted_position
	$WiggleTween.interpolate_property(self, 'position', position - s, position + d, wiggle_duration, Tween.TRANS_BOUNCE, Tween.EASE_OUT_IN)
	$WiggleTween.start()
