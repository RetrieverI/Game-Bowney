extends CharacterBody2D

@onready var player = %player

var speed = 200
var health = 10
var stay = false

func _process(delta):
	if stay:
		velocity = Vector2.ZERO
	else:
		var direction = (player.global_position - position).normalized()
		velocity = direction * speed
		
	move_and_slide()
		
func _on_stay_body_entered(body):
	if body == player:
		stay = true
		print("companion is staying")
	
func _on_stay_body_exited(body):
	if body == player:
		stay = false
