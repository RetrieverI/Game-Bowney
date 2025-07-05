extends Area2D

@onready var timer = $Timer

var can_pickup = true

func _on_body_entered(body):
	if body.is_in_group("players") and body.health_potion < 3 and can_pickup:
		body.health_potion += 1
		
		can_pickup = false
		visible = false
		timer.start()
		
func _on_timer_timeout():
	visible = true
	can_pickup = true
