extends Area2D

func _on_body_entered(body):
	if body.is_in_group("players") and body.health_potion < 2:
		body.health_potion += 1
		print("health potions: ", body.health_potion)
		queue_free()
