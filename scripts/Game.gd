extends Node

signal game_over

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	if Input.is_action_just_released('help'):
		$HelpMenu/MenuItems.visible = !$HelpMenu/MenuItems.visible

func _on_Player_die():
	emit_signal("game_over")
