extends Area2D

@onready var player = $"../player"
@onready var enemy = $"../enemy"

var speed = 1000
var direction = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	#enemy.health -= 5
	body.queue_free()
	queue_free()
	#print("shadow realm")
	player.kill_count += 1
	print("kills: ", player.kill_count)
