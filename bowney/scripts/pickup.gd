extends Area2D

@onready var player = $"../player"

func _on_body_entered(player):
	player.count += 5
	print("pickup collected")
	print("arrows: ", player.count)
	queue_free()
