extends Node

signal start_game

func _ready():
	var start_position = $Title.position
	var end_position = Vector2(start_position.x, 10.0)
	var error = $TitleTween.interpolate_property($Title, 'position', start_position, end_position, .5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$TitleTween.start()

func _on_StartButton_pressed():
	emit_signal("start_game")
