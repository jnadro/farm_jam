extends Area2D

signal taunt_timedout

# class member variables go here, for example:
onready var game = get_node("/root/Game")

func _ready():
	pass

func _process(delta):
	pass

func _on_Timer_timeout():
	emit_signal("taunt_timedout")
	queue_free()

func _on_TauntBomb_body_entered(body):
	if body.is_in_group("mobs"):
		body.taunt(self)
		connect("taunt_timedout", body, "_on_taunt_timeout")
