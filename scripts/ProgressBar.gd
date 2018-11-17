extends Node2D

signal progress_completed

# class member variables go here, for example:

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func start(duration):
	$Tween.interpolate_property($TextureProgress,
            'value', 0, 100,
            duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func stop():
	$Tween.stop_all()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Tween_tween_completed(object, key):
	emit_signal("progress_completed")
