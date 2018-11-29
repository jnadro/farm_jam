extends Node2D

signal harvestable

# class member variables go here, for example:
export(String) var crop_type = "Potato"
export(float) var growth_time = 5.0
export(int) var sell_price = 60
var harvestable = false
var planted_position = null
var crop_animated_sprite = null

func _ready():
	crop_animated_sprite = AnimatedSprite.new()
	var sprite_frames = SpriteFrames.new()
	crop_animated_sprite.set_sprite_frames(sprite_frames)
	crop_animated_sprite.animation = "Grow"
	crop_animated_sprite.set_centered(false)
	add_child(crop_animated_sprite)
	
	sprite_frames.add_animation("Grow")
	sprite_frames.set_animation_loop("Grow", false)
	var base_path = "res://resources/textures/"
	var resource_path = base_path + crop_type + "/"
	sprite_frames.add_frame("Grow", load(base_path + "Planted.png"))
	sprite_frames.add_frame("Grow", load(resource_path + "Seed.png"))
	sprite_frames.add_frame("Grow", load(resource_path + "Stage1.png"))
	sprite_frames.add_frame("Grow", load(resource_path + "Stage2.png"))
	sprite_frames.add_frame("Grow", load(resource_path + "Stage3.png"))
	sprite_frames.add_frame("Grow", load(resource_path + "Stage4.png"))	
	sprite_frames.add_frame("Grow", load(resource_path + crop_type + ".png"))
	
	var fps = sprite_frames.get_frame_count("Grow") / growth_time
	sprite_frames.set_animation_speed("Grow", fps )
	crop_animated_sprite.play()
	$GrowthTimer.wait_time = growth_time
	$GrowthTimer.start()
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	#if harvestable:
	#	print(position)
	pass

func _on_GrowthTimer_timeout():
	crop_animated_sprite.stop()
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

func can_eat():
	if crop_type == "Tomato":
		return true
	return false

func give_health():
	return 30
