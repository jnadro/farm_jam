extends CanvasLayer

# class member variables go here, for example:
onready var seed_pouch = get_node("/root/Game/SeedPouch")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Seed_picked_up():
	$ArtichokeSeedLabel.text = str(seed_pouch.get_artichoke_seed_count())
	$CucumberSeedLabel.text = str(seed_pouch.get_cucumber_seed_count())
	$PotatoSeedLabel.text = str(seed_pouch.get_potato_seed_count())	
	$TomatoSeedLabel.text = str(seed_pouch.get_tomato_seed_count())
