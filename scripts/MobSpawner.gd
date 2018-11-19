extends Node2D

onready var game = get_node("/root/Game")

export (PackedScene) var Mob
export (float) var SpawnRate

func _ready():
	$MobTimer.wait_time = SpawnRate

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_MobTimer_timeout():
	# spawn a mob
	var mob = Mob.instance()
	mob.position = global_position
	mob.connect("die", self, "_on_mob_die")
	game.add_child(mob)

func _on_mob_die(mob):
	GameState.add_score(10)
	# Randomly spawn a seed inside a radius 10 circle
	# around the mob position
	var seed_spawn_radius = 10.0
	var rand_x = randf() * 2.0 - 1.0
	var rand_y = randf() * 2.0 - 1.0
	var spawn_offset = Vector2(rand_x * seed_spawn_radius, rand_y * seed_spawn_radius)
	GameState.spawn_random_seed(mob.global_position + spawn_offset)
	remove_child(mob)
	