extends Area2D

func _on_body_entered(body):
	#print ("dead")
	get_tree().reload_current_scene()
	
