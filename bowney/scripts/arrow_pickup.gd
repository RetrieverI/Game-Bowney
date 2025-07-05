extends Area2D

@onready var timer = $Timer

var can_pickup = true

func _on_body_entered(body):
	if body.is_in_group("players") and body.arrow_count <= 10 and can_pickup:
		body.arrow_count += 5
		print("arrows: ", body.arrow_count)
		
		can_pickup = false
		visible = false
		timer.start()

func _on_timer_timeout():
	visible = true
	can_pickup = true
