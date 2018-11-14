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
var score = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func has_seeds():
	return seed_counts[active_seed] > 0
	
func get_seed():
	if has_seeds():
		seed_counts[active_seed] -= 1
		hud.update_labels()
		var seed_instance = seed_scene.instance()
		seed_instance.connect("picked_up", self, "_on_Seed_picked_up")
		return seed_instance
		
func add_coins(num_coins):
	coin_count += num_coins
	hud.update_labels()	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

# Connections
func _on_Seed_picked_up():
	seed_counts["Potato"] += 1
	hud.update_labels()

