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

func update_labels(seed_counts, coin_count):
	$ArtichokeSeedLabel.text = str(seed_counts["Artichoke"])
	$CucumberSeedLabel.text = str(seed_counts["Cucumber"])
	$PotatoSeedLabel.text = str(seed_counts["Potato"])
	$TomatoSeedLabel.text = str(seed_counts["Tomato"])
	$CoinCountLabel.text = str(coin_count)
