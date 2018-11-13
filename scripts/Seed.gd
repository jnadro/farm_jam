extends Area2D

signal picked_up

# class member variables go here, for example:
export (String) var type
var crop_script = preload("res://scenes/Crop.tscn")
var taken = false

#func _ready():
#	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func spawn_crop():
	return crop_script.instance()


func _on_Seed_area_entered(area):
	if not taken and area is preload("res://scripts/Player.gd"):
		emit_signal("picked_up")
		hide()
		taken = true
