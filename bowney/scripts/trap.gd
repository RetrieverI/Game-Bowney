extends Area2D

@onready var player = %player

func _on_body_entered(body):
	if player.activate_trap:
		if body.is_in_group("players") or body.is_in_group("enemies"):
			body.health -= 10
			queue_free()
