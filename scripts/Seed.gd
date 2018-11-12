extends Area2D

signal picked_up

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (String) var type
var taken = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Seed_area_entered(area):
	if not taken and area is preload("res://scripts/Player.gd"):
		emit_signal("picked_up")
		hide()
		taken = true
