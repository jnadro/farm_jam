extends Node

onready var MainMenuScene = preload("res://scenes/MainMenu.tscn")
onready var GameScene = preload("res://scenes/Game.tscn")
onready var GameOverScene = preload("res://scenes/GameOver.tscn")

var main_menu = null
var game = null
var game_over = null

func _ready():
	main_menu = MainMenuScene.instance()
	main_menu.connect("start_game", self, "_on_start_game")
	add_child(main_menu)
	
func _on_start_game():
	game = GameScene.instance()
	game.connect("game_over", self, "_on_game_over")
	remove_child(main_menu)
	main_menu = null
	add_child(game)
	
func _on_game_over():
	game_over = GameOverScene.instance()
	remove_child(game)
	game = null
	add_child(game_over)
