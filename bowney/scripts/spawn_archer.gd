extends Marker2D

@onready var enemy_scene = load("res://scenes/bow_enemy.tscn")
@onready var timer = $Timer
@onready var player = %player

var can_spawn = true
var kill_check = 0

func _process(delta):
	if can_spawn:	
		var enemy = enemy_scene.instantiate()
		enemy.global_position = global_position
		get_tree().get_current_scene().add_child(enemy)
		can_spawn = false
		timer.start()

	if player.kill_count >= kill_check + 10 and timer.wait_time > 1:
		timer.wait_time -= 1
		kill_check += 10

func _on_timer_timeout():
	can_spawn = true
