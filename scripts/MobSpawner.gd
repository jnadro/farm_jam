extends Node2D

var Chicken
var Cow
var Bluejay
var Pig
export (float) var SpawnRate
var wave_idx = 0

func _ready():
	$MobTimer.wait_time = SpawnRate
	$MobTimer.start()
	Cow = load("res://scenes/Cow.tscn")
	Chicken = load("res://scenes/Chicken.tscn")
	Bluejay = load("res://scenes/Bluejay.tscn")
	Pig = load("res://scenes/Pig.tscn")


func get_random_position():	
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.set_offset(randi())
	return $MobPath/MobSpawnLocation.position
	
func get_mob_spawn_count():
	if wave_idx < 3:
		return 1
	elif wave_idx < 6:
		return 2
	elif wave_idx < 9:
		return 3
	elif wave_idx < 12:
		return 4
	return 5
	
func get_random_point_in_circle(center):
	var r = 64.0
	var rand_x = randf() * 2.0 - 1.0
	var rand_y = randf() * 2.0 - 1.0
	var offset = Vector2(rand_x * r, rand_y * r)
	return center + offset

func _on_MobTimer_timeout():
	var count = get_mob_spawn_count()
	var wave_position = get_random_position()
	for i in range(count):
		# spawn a mob
		var mob = random_instance()
		mob.position = get_random_point_in_circle(wave_position)
		mob.connect("die", self, "_on_mob_die")
		mob.add_to_group("mobs")
		get_parent().add_child(mob)
	
	wave_idx += 1
	
	# start the time again
	$MobTimer.start()
	
func random_instance ():
	var integer = randi()%11+1
	
	if integer >= 1 and integer < 6:
		return Bluejay.instance()
	elif integer >= 6 and integer <= 8:
		return Chicken.instance()
	elif integer == 9:
		return Pig.instance()
	else:
		return Cow.instance()

func _on_mob_die(mob):
	var GameState = get_parent().get_node("GameState")
	# Randomly spawn a seed inside a radius 10 circle
	# around the mob position
	var seed_spawn_radius = 10.0
	var rand_x = randf() * 2.0 - 1.0
	var rand_y = randf() * 2.0 - 1.0
	var spawn_offset = Vector2(rand_x * seed_spawn_radius, rand_y * seed_spawn_radius)
	GameState.spawn_random_seed(mob.global_position + spawn_offset)
	get_parent().remove_child(mob)
	
