extends Node
var Cow
var Chicken
var Bluejay
var Pig

func _ready():
	Cow = load("res://scenes/Cow.tscn")
	Chicken = load("res://scenes/Chicken.tscn")
	Bluejay = load("res://scenes/Bluejay.tscn")
	Pig = load("res://scenes/Pig.tscn")

func _process(delta):
	pass

func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.set_offset(randi())
	# Create a Mob instance and add it to the scene.
	var mob = Chicken.instance()
	mob.position = $MobPath/MobSpawnLocation.position
	add_child(mob)
