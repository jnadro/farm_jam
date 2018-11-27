extends CanvasLayer

func _process(delta):
	update_labels()

func update_labels():
	var GameState = get_parent().get_node("GameState")
	$ArtichokeSeedLabel.text = str(GameState.seed_counts["Artichoke"])
	$CucumberSeedLabel.text = str(GameState.seed_counts["Cucumber"])
	$PotatoSeedLabel.text = str(GameState.seed_counts["Potato"])
	$TomatoSeedLabel.text = str(GameState.seed_counts["Tomato"])
	
	$ArtichokeInvLabel.text = str(GameState.crop_inventory["Artichoke"])
	$CucumberInvLabel.text = str(GameState.crop_inventory["Cucumber"])
	$PotatoInvLabel.text = str(GameState.crop_inventory["Potato"])
	$TomatoInvLabel.text = str(GameState.crop_inventory["Tomato"])
	
	$Selected.position.x = GameState.equipped_seed_index * GameState.TILE_SIZE * 2
	
	$PlayerStats/HealthBar.value = GameState.player.health
	
	$Score/ScoreValue.text = str(GameState.score)
