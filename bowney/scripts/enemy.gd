extends CharacterBody2D

var speed = 100
#var health = 10

@onready var player = $"../player"

func _process(delta):
	var direction = (player.global_position - position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	#if health < 0:
	#	queue_free()
