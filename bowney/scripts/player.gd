extends CharacterBody2D

@onready var trapscene = load("res://scenes/trap.tscn")
@onready var arrowscene = load("res://scenes/arrow.tscn")
@onready var melee_area = $melee
@onready var melee_cooldown = $meleecooldown
@onready var bow_cooldown = $bowcooldown
@onready var dash_cooldown = $dashcooldown
@onready var activate = $activate
@onready var hud = %hud
@onready var triple_cooldown = $triplecooldown
#@onready var death_screen = $"res://scenes/death_screen.tscn"

var can_melee = true
var can_shoot = true
var can_dash = true
var activate_trap = false
var can_triple = true

var speed = 800
var dash = 20000
var arrow_count = 10
var kill_count = 0
var health = 10
var health_potion = 1
var traps = 1

func _physics_process(delta):
	if Input.is_action_just_pressed("dash") and can_dash:
		speed = dash
		can_dash = false
		dash_cooldown.start()
	else:
		speed = 800
	
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
	
	
	if Input.is_action_just_pressed("shoot") and arrow_count > 0 and can_shoot:
		var arrow = arrowscene.instantiate()
		arrow.position = global_position
		
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		arrow.direction = direction
		arrow.rotation = direction.angle()
		get_tree().get_current_scene().add_child(arrow)
		
		arrow_count -= 1
		#print("arrows: ", arrow_count)
		can_shoot = false
		bow_cooldown.start()
	
	if Input.is_action_just_pressed("triple_shoot") and arrow_count >= 3 and can_triple:
		var base_direction = (get_global_mouse_position() - global_position).normalized()
		
		for angle_offset in [-10, 0, 10]:
			var arrow = arrowscene.instantiate()
			var direction = base_direction.rotated(deg_to_rad(angle_offset))
			arrow.global_position = global_position
			arrow.direction = direction
			arrow.rotation = direction.angle()
			get_tree().current_scene.add_child(arrow)
		
		arrow_count -= 3
		can_triple = false
		triple_cooldown.start()
	
	if Input.is_action_just_pressed("melee") and can_melee:
		var bodies = melee_area.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("enemies"):
				body.health -= 10
				can_melee = false
				melee_cooldown.start()
				break
	
	if Input.is_action_just_pressed("heal") and health < 10 and health_potion > 0:
		health += 5
		if health > 10:
			health = 10
		health_potion -= 1
		print("player health: ", health)
		print("health potions: ", health_potion)
	
	if Input.is_action_just_pressed("trap") and traps > 0 and velocity.length() <= 0:
		var trap = trapscene.instantiate()
		trap.position = global_position
		get_tree().current_scene.add_child(trap)
		
		traps -= 1
		print("traps: ", traps)
		activate.start()
			
	if health <= 0:
		var death_screen = preload("res://scenes/death_screen.tscn").instantiate()
		#death_screen.update_kills(kill_count)
		get_tree().current_scene.add_child(death_screen)
	
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/control.tscn")
	
	hud.update_stats(health, arrow_count, kill_count, health_potion, traps)
	
func _on_meleecooldown_timeout():
	can_melee = true

func _on_bowcooldown_timeout():
	can_shoot = true

func _on_dashcooldown_timeout():
	can_dash = true

func _on_activate_timeout():
	activate_trap = true

func _on_triplecooldown_timeout():
	can_triple = true
