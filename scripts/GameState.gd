extends Node

# constants
const TILE_SIZE = 32

# class member variables go here, for example:
onready var hud = get_node("/root/Game/HUD")
onready var game = get_node("/root/Game")

var crop_names = ["Artichoke", "Cucumber", "Potato", "Tomato"]

var equipped_seed_index = 0
# dictionary that map crop name string to counts
var seed_counts = {}
# dictionary that maps crop names to how many crops you are carrying
var crop_inventory = {}
# dictionary that map crop name string to scenes
var crop_scenes = {}
var seed_scene = load("res://scenes/Seed.tscn")
var picked_up_seed = null
var score = 0

const seed_drop_chance = 0.25

onready var player = get_node("/root/Game/Player")

func _ready():
	for crop in crop_names:
		seed_counts[crop] = 0
		crop_inventory[crop] = 0
		crop_scenes[crop] = load("res://scenes/" + crop + ".tscn")	
	crop_inventory["Potato"] += 20
	
func add_score(val):
	score += val
	
func has_seeds():
	return seed_counts[crop_names[equipped_seed_index]] > 0
	
func spawn_random_seed(position):
	var r = 1 - randf()
	if r <= seed_drop_chance:
		var new_seed = seed_scene.instance()
		new_seed.position = position
		var rand_crop_idx = randi() % crop_names.size()
		new_seed.type = crop_names[rand_crop_idx]
		game.get_node("Seeds").add_child(new_seed)
		
func plant_active_crop():
	if has_seeds():
		var seed_name = crop_names[equipped_seed_index]
		seed_counts[seed_name] -= 1
		hud.update_labels()
		return crop_scenes[seed_name].instance()
	return null
		
func add_crop_to_inventory(crop_type, count):
	crop_inventory[crop_type] += count
	hud.update_labels()
	
func has_crop_in_inventory(crop_type):
	return crop_inventory[crop_type] > 0

func get_crop_count_in_inventory(crop_type):
	return crop_inventory[crop_type]
	
func empty_crop_inventory(crop_type):
	var crop_count = crop_inventory[crop_type]
	crop_inventory[crop_type] = 0
	hud.update_labels()
	return crop_count

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if Input.is_action_just_released("pick_seed"):
		equipped_seed_index = (equipped_seed_index + 1) % crop_names.size()
		hud.update_labels()
	
# Connections
func _on_Seed_picked_up(_seed):
	picked_up_seed = _seed
	print(picked_up_seed)
	seed_counts[picked_up_seed.type] += 1
	hud.update_labels()
	
func _on_Player_player_took_damage():
	hud.update_labels()

