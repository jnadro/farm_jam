extends Area2D

# class member variables go here, for example:
onready var ProgressBar = preload("res://scenes/ProgressBar.tscn")
onready var Crop = preload("res://scenes/Crop.tscn")
var pressed = false
var progress_bar = null
var planting_time = 1.0
var crop = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func occupied():
	return crop != null

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

func _on_CropSpawn_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !occupied():
			if event.pressed:
				pressed = true
				progress_bar = ProgressBar.instance()
				add_child(progress_bar)
				progress_bar.start(planting_time)
				progress_bar.connect("progress_completed", self, "_planting_completed")
			elif !event.pressed and pressed:
				remove_child(progress_bar)
				progress_bar = null
		
func _planting_completed():
	remove_child(progress_bar)
	progress_bar = null
	
	crop = Crop.instance()
	crop.growth_time = 1.0
	add_child(crop)


func _on_CropSpawn_mouse_entered():
	if !occupied():
		$Highlight.show()


func _on_CropSpawn_mouse_exited():
	if progress_bar:
		remove_child(progress_bar)
	$Highlight.hide()
