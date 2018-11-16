extends CanvasLayer

# class member variables go here, for example:

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func update_labels():
	$ArtichokeSeedLabel.text = str(GameState.seed_counts["Artichoke"])
	$CucumberSeedLabel.text = str(GameState.seed_counts["Cucumber"])
	$PotatoSeedLabel.text = str(GameState.seed_counts["Potato"])
	$TomatoSeedLabel.text = str(GameState.seed_counts["Tomato"])
	$CoinCountLabel.text = str(GameState.coin_count)
	$Selected.position.x = GameState.equipped_seed_index * GameState.TILE_SIZE * 2
