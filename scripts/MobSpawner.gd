extends Node2D

export (float) var SpawnRate
export (PackedScene) var Cow
export (PackedScene) var Chicken
export (PackedScene) var Pig
export (PackedScene) var Pack

func _ready():
	$MobTimer.wait_time = SpawnRate
	$MobTimer.start()

func get_random_position():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.set_offset(randi())
	return $MobPath/MobSpawnLocation.position

func _on_MobTimer_timeout():
	var num_spawns = 3
	var pack = Pack.instance()
	pack.position = get_random_position()
	
	for i in range(num_spawns):
		var rand_int = 1#randi() % 3
		var mob_type = Chicken
		match rand_int:
			0:
				mob_type = Cow
			1:
				mob_type = Chicken
			2:
				mob_type = Pig
		# spawn a mob
		var mob = mob_type.instance()
		mob.connect("die", self, "_on_mob_die")
		mob.add_to_group("mobs")
		pack.get_node("Spawn" + str(i)).add_child(mob)
		
	get_parent().add_child(pack)
	
	# start the time again
	$MobTimer.start()

func _on_mob_die(mob):
	var GameState = get_parent().get_node("GameState")
	GameState.add_score(10)
	# Randomly spawn a seed inside a radius 10 circle
	# around the mob position
	var seed_spawn_radius = 10.0
	var rand_x = randf() * 2.0 - 1.0
	var rand_y = randf() * 2.0 - 1.0
	var spawn_offset = Vector2(rand_x * seed_spawn_radius, rand_y * seed_spawn_radius)
	GameState.spawn_random_seed(mob.global_position + spawn_offset)
	mob.get_parent().remove_child(mob)
	mob.queue_free()
	