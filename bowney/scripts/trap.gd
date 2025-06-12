extends Area2D

#@onready var player = %player

func _on_body_entered(body):
	if body.is_in_group("players") and body.activate_trap:
		body.health -= 10
		queue_free()
	elif body.is_in_group("enemies"):
		body.health -= 10
		queue_free()
