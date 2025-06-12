extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players") and body.traps < 3:
		body.traps += 1
		print("traps: ", body.traps)
		queue_free()
