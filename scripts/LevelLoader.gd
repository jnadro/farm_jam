extends Node

onready var MainMenuScene = preload("res://scenes/MainMenu.tscn")
onready var GameScene = preload("res://scenes/Game.tscn")

var main_menu = null
var game = null

func _ready():
	main_menu = MainMenuScene.instance()
	main_menu.connect("start_game", self, "_on_start_game")
	add_child(main_menu)
	
func _on_start_game():
	game = GameScene.instance()
	remove_child(main_menu)
	main_menu = null
	add_child(game)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
