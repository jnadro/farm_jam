extends Node

# class member variables go here, for example:
onready var hud = get_node("/root/Game/HUD")
onready var seed_scene = preload("res://scenes/Seed.tscn")
var active_seed = "Potato"
var seed_counts = {
	"Artichoke": 0,
	"Cucumber": 0,
	"Potato": 0,
	"Tomato": 0,
}
var coin_count = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func has_seeds():
	return seed_counts[active_seed] > 0
	
func get_seed():
	if has_seeds():
		seed_counts[active_seed] -= 1
		hud.update_labels(seed_counts, coin_count)		
		return seed_scene.instance()
		
func get_artichoke_seed_count():
	return seed_counts["Artichoke"]
	
func get_cucumber_seed_count():
	return seed_counts["Cucumber"]

func get_potato_seed_count():
	return seed_counts["Potato"]
	
func get_tomato_seed_count():
	return seed_counts["Tomato"]
	
func get_coin_count():
	return coin_count
	
func add_coins(num_coins):
	coin_count += num_coins
	hud.update_labels(seed_counts, coin_count)	

func _on_Seed_picked_up():
	seed_counts["Potato"] += 1
	hud.update_labels(seed_counts, coin_count)
