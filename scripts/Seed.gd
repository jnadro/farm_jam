extends Area2D

signal picked_up(_seed)

# class member variables go here, for example:
export (String) var type = "Potato"
var crop_scene = null
var taken = false

func _ready():
	var GameState = get_parent().get_node("GameState")
	var resource_path = "res://resources/textures/" + type + "/"
	$Sprite.texture = load(resource_path + "Seeds.png")
	connect("picked_up", GameState, "_on_Seed_picked_up")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Seed_area_entered(area):
	if not taken and area is preload("res://scripts/Player.gd"):
		$PickupSeedAudio.play()
		emit_signal("picked_up", self)
		hide()
		taken = true
