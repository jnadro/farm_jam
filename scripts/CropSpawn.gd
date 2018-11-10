extends Area2D

# class member variables go here, for example:
onready var ProgressBar = preload("res://scenes/ProgressBar.tscn")
onready var Crop = preload("res://scenes/Crop.tscn")
var pressed = false
var progress_bar = null
var planting_time = 1.0
var crop = null
var player_nearby = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func occupied():
	return crop != null

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

func stop_progress():
	remove_child(progress_bar)
	progress_bar = null

func _on_CropSpawn_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !occupied() && player_nearby:
			if event.pressed:
				pressed = true
				progress_bar = ProgressBar.instance()
				add_child(progress_bar)
				progress_bar.start(planting_time)
				progress_bar.connect("progress_completed", self, "_planting_completed")
			elif !event.pressed and pressed:
				stop_progress()
		
func _planting_completed():
	stop_progress()
	
	crop = Crop.instance()
	crop.growth_time = 1.0
	add_child(crop)


func _on_CropSpawn_mouse_entered():
	if !occupied() && player_nearby:
		$Highlight.show()


func _on_CropSpawn_mouse_exited():
	if progress_bar:
		stop_progress()
	$Highlight.hide()


func _on_CropSpawn_area_entered(area):
	if area.is_in_group("Player"):
		player_nearby = true


func _on_CropSpawn_area_exited(area):
	if area.is_in_group("Player"):
		player_nearby = false
		if progress_bar:
			stop_progress()
			$Highlight.hide()
