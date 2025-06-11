extends Area2D

var can_hit = false

func _on_body_entered(body):
	if body.is_in_group("players"):
		body.health -= 5
		print("Player health:", body.health)
