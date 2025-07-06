extends CanvasLayer

@onready var health_label = $MarginContainer/VBoxContainer/HBoxContainer2/health
#@onready var kill_label = $MarginContainer/VBoxContainer/kill
@onready var health_potion_label = $MarginContainer/VBoxContainer/HBoxContainer/healthpotion
@onready var arrow_label = $MarginContainer/VBoxContainer/HBoxContainer3/arrow
@onready var traps_label = $MarginContainer/VBoxContainer/HBoxContainer4/traps

func update_stats(health, arrow_count, kill_count, health_potion, traps):
	health_label.text = "Health: " + str(health)
	#kill_label.text = "Kills: " + str(kill_count)
	health_potion_label.text = "Health potions: " + str(health_potion)
	arrow_label.text = "Arrows: " + str(arrow_count)
	traps_label.text = "Traps: " + str(traps)
