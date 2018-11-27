extends Node

signal start_game

func _ready():
	var start_position = $Title.position
	var end_position = Vector2(start_position.x, 10.0)
	$TitleTween.interpolate_property($Title, "position", start_position, end_position, .5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$TitleTween.start()
	
	var start_color = $ColorRect.color
	var end_color = Color(start_color.r, start_color.g, start_color.b, 0.6)
	$AlphaTween.interpolate_property($ColorRect, "color", start_color, end_color, 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$AlphaTween.start()

func _on_StartButton_pressed():
	emit_signal("start_game")
