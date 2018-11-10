extends Node2D

signal harvestable

# class member variables go here, for example:
export(float) var growth_time = 5.0
var harvestable = false

func _ready():
	var sprite_frames = $AnimatedSprite.get_sprite_frames()
	var fps = sprite_frames.get_frame_count("Grow") / growth_time
	sprite_frames.set_animation_speed("Grow", fps )
	$AnimatedSprite.play()
	$GrowthTimer.wait_time = growth_time
	$GrowthTimer.start()
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	#if harvestable:
	#	print(position)
	pass

func _on_GrowthTimer_timeout():
	harvestable = true
	emit_signal("harvestable")
	$WiggleTimer.start()


func _on_WiggleTimer_timeout():
	var s = Vector2(randf() * 2.0, 0)
	var d = Vector2(randf() * 2.0, 0)
	var wiggle_duration = randf() * 2.0
	$WiggleTween.interpolate_property(self, 'position', position - s, position + d, wiggle_duration, Tween.TRANS_BOUNCE, Tween.EASE_OUT_IN)
	$WiggleTween.start()
