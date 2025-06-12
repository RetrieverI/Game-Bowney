extends CharacterBody2D

var speed = 700
var health = 5

@onready var player = %player

func _process(delta):
	var direction = (player.global_position - position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	if health <= 0:
		player.kill_count += 1
		print("kills: ", player.kill_count)
		queue_free()

func _on_hit_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.health -= 2
		print("Player health:", body.health)
