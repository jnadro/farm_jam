extends Node2D

export (PackedScene) var Mob

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_MobTimer_timeout():
	# spawn a mob
	var mob = Mob.instance()
	mob.position = Vector2(100, 100)
	add_child(mob)
