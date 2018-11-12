extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var active_seed = "Potato"
var seed_counts = {
	"Artichoke": 0,
	"Cucumber": 0,
	"Potato": 0,
	"Tomato": 0,
}

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
		return
		
func get_artichoke_seed_count():
	return seed_counts["Artichoke"]
	
func get_cucumber_seed_count():
	return seed_counts["Cucumber"]

func get_potato_seed_count():
	return seed_counts["Potato"]
	
func get_tomato_seed_count():
	return seed_counts["Tomato"]

func _on_Seed_picked_up():
	print("Seed added to pouch!")
	seed_counts["Potato"] += 1
	print(seed_counts)
