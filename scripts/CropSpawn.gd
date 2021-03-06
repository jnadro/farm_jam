extends Area2D

# class member variables go here, for example:
enum STATES { PLANT, GROWING, HARVEST }
onready var ProgressBar = preload("res://scenes/ProgressBar.tscn")
onready var Crop = preload("res://scenes/Crop.tscn")
onready var GameState = get_node("../../GameState")
var state = STATES.PLANT
var pressed = false
var progress_bar = null
var planting_time = 1.0
var crop = null
var player_nearby = false

	
func occupied():
	return crop != null

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

func start_progress(callback):
	progress_bar = ProgressBar.instance()
	add_child(progress_bar)
	progress_bar.start(planting_time)
	progress_bar.connect("progress_completed", self, callback)
	
func stop_progress():
	remove_child(progress_bar)
	progress_bar = null

func _on_CropSpawn_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if state == STATES.PLANT:
			if !occupied() && player_nearby && GameState.has_seeds():
				if event.pressed:
					pressed = true
					start_progress("_planting_completed")
				elif !event.pressed and pressed:
					stop_progress()
		elif state == STATES.HARVEST:
			if player_nearby:
				if event.pressed:
					pressed = true
					start_progress("_harvest_completed")
				elif !event.pressed and pressed:
					stop_progress()
		
func _planting_completed():
	stop_progress()
	
	crop = GameState.plant_active_crop()
	crop.connect("harvestable", self, "_on_crop_harvestable")
	add_child(crop)
	$Highlight.hide()
	state = STATES.GROWING
	
func _on_crop_harvestable():
	$CropReady.play()
	state = STATES.HARVEST

func _harvest_completed():
	GameState.add_crop_to_inventory(crop.crop_type, 1)
	remove_child(crop)
	stop_progress()
	$HarvestAudio.play()
	state = STATES.PLANT
	GameState.add_score(1)

func _on_CropSpawn_mouse_exited():
	if progress_bar:
		stop_progress()

func _on_CropSpawn_area_entered(area):
	if area is preload("res://scripts/Player.gd"):
		if state == STATES.PLANT or state == STATES.HARVEST:
			$Highlight.show()		
		player_nearby = true

func _on_CropSpawn_area_exited(area):
	if area is preload("res://scripts/Player.gd"):
		$Highlight.hide()
		player_nearby = false
		if progress_bar:
			stop_progress()
