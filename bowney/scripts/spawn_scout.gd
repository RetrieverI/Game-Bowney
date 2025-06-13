extends Marker2D

@onready var enemy_scene = load("res://scenes/scout.tscn")
@onready var timer = $Timer

var can_spawn = true

func _process(delta):
	if can_spawn:	
		var enemy = enemy_scene.instantiate()
		enemy.global_position = global_position
		get_tree().get_current_scene().add_child(enemy)
		can_spawn = false
		timer.start()

func _on_timer_timeout():
	can_spawn = true
