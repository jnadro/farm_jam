extends Node2D

export (PackedScene) var Mob
export (float) var SpawnRate

func _ready():
	$MobTimer.wait_time = SpawnRate
	$MobTimer.start()

func get_random_position():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.set_offset(randi())
	return $MobPath/MobSpawnLocation.position

func _on_MobTimer_timeout():
	# spawn a mob
	var mob = Mob.instance()
	mob.position = get_random_position()
	mob.connect("die", self, "_on_mob_die")
	mob.add_to_group("mobs")
	get_parent().add_child(mob)
	
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
	get_parent().remove_child(mob)
	