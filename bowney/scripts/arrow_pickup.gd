extends Area2D

func _on_body_entered(body):
	if body.is_in_group("players") and body.arrow_count < 15:
		body.arrow_count += 5
		print("arrows: ", body.arrow_count)
		queue_free()
