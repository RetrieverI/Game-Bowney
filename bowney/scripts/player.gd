extends CharacterBody2D

@onready var arrowscene = load("res://scenes/arrow.tscn")
@onready var melee_area = $melee
@onready var melee_cooldown = $meleecooldown
@onready var bow_cooldown = $bowcooldown

var can_melee = true
var can_shoot = true

var speed = 800
var count = 10
var kill_count = 0

func _process(delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("shoot") and count > 0 and can_shoot:
		var arrow = arrowscene.instantiate()
		arrow.position = global_position
		
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		arrow.direction = direction
		arrow.rotation = direction.angle()
		
		get_tree().get_current_scene().add_child(arrow)
		
		count -= 1
		print("arrows: ", count)
		can_shoot = false
		bow_cooldown.start()
	
	if Input.is_action_just_pressed("melee") and can_melee:
		var bodies = melee_area.get_overlapping_bodies()
		for enemy in bodies:
			enemy.queue_free()
			#print("shanked")
			kill_count +=1
			print("kills: ", kill_count)
			can_melee = false
			melee_cooldown.start()
			break

func _on_meleecooldown_timeout():
	can_melee = true

func _on_bowcooldown_timeout():
	can_shoot = true
