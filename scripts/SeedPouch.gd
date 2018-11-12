extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
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

func _on_Seed_picked_up():
	print("Seed added to pouch!")
	seed_counts["Potato"] += 1
	print(seed_counts)
