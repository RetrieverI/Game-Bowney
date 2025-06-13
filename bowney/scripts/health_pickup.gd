extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	if body.is_in_group("players") and body.health_potion < 3:
		body.health_potion += 1
		
		visible = false
		timer.start()
		
func _on_timer_timeout():
	visible = true
