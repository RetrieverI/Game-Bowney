extends Area2D

@onready var arrow_travel = $arrowtravel

var speed = 300
var direction = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta
	
func _on_body_entered(body):
	if body.is_in_group("players"):
		body.health -= 5
		print("player health: ", body.health)
	queue_free()

func _on_arrowtravel_timeout():
	queue_free()
