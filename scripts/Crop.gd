extends Node2D

signal harvestable

# class member variables go here, for example:
export(String) var crop_type = "potato"
export(float) var growth_time = 5.0
export(int) var sell_price = 60
var harvestable = false
var planted_position = null

func _ready():
	var sprite_frames = $AnimatedSprite.get_sprite_frames()
	sprite_frames.add_animation("Grow")
	sprite_frames.set_animation_loop("Grow", false)
	var resource_path = "res://resources/textures/" + crop_type + "/"
	sprite_frames.add_frame("Grow", load(resource_path + "Seed.png"))
	sprite_frames.add_frame("Grow", load(resource_path + "Stage1.png"))
	sprite_frames.add_frame("Grow", load(resource_path + "Stage2.png"))
	sprite_frames.add_frame("Grow", load(resource_path + "Stage3.png"))
	sprite_frames.add_frame("Grow", load(resource_path + "Stage4.png"))	
	sprite_frames.add_frame("Grow", load(resource_path + crop_type + ".png"))
	
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
	planted_position = position
	emit_signal("harvestable")
	$WiggleTimer.start()


func _on_WiggleTimer_timeout():
	var s = Vector2(randf() * 2.0, 0)
	var d = Vector2(randf() * 2.0, 0)
	var wiggle_duration = randf() * 2.0
	position = planted_position
	$WiggleTween.interpolate_property(self, 'position', position - s, position + d, wiggle_duration, Tween.TRANS_BOUNCE, Tween.EASE_OUT_IN)
	$WiggleTween.start()
