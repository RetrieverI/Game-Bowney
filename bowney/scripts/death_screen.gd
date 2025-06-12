extends CanvasLayer

@onready var kill_label = $Control/MarginContainer/VBoxContainer/Label2

func update_kills(kill_count):
	kill_label = "Kills: " + str(kill_count)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/control.tscn")
