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
@onready var sprite = $AnimatedSprite2D
#@onready var death_screen = $"res://scenes/death_screen.tscn"

var can_melee = true
var can_shoot = true
var can_dash = true
var activate_trap = false
var can_triple = true
var can_rotate = true

var speed = 200
var dash_dist = 4000
var arrow_count = 25
var kill_count = 0
var health = 10
var health_potion = 1
var traps = 1

#UI things:
var dead = false
var paused = false

func movement():
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
		#sprite.play("move")

	move_and_slide()

func dash():
	if Input.is_action_just_pressed("dash") and can_dash:
		speed = dash_dist
		can_dash = false
		dash_cooldown.start()
		sprite.play("dash")
	else:
		speed = 200

func camera():
	if can_rotate:
		var direction = get_global_mouse_position() - global_position
		rotation = direction.angle() + deg_to_rad(90)
	
func shoot():
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
		sprite.play("bow")

func triple_shoot():
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
		sprite.play("bow")

func melee():
	if Input.is_action_just_pressed("melee") and can_melee:
		sprite.play("melee")
		var bodies = melee_area.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("enemies"):
				body.health -= 10
				can_melee = false
				melee_cooldown.start()
				break

func heal():
	if Input.is_action_just_pressed("heal") and health < 10 and health_potion > 0:
		health += 5
		if health > 10:
			health = 10
		health_potion -= 1
		print("player health: ", health)
		print("health potions: ", health_potion)
		sprite.play("heal")
		
func trap():
	if Input.is_action_just_pressed("trap") and traps > 0 and velocity.length() <= 0:
		var trap = trapscene.instantiate()
		trap.position = global_position
		get_tree().current_scene.add_child(trap)
		
		traps -= 1
		print("traps: ", traps)
		activate.start()
		sprite.play("trap")

func death():
	if health <= 0 and not dead:
		Engine.time_scale = 0
		#queue_free()
		hud.hide()
		var death_screen = preload("res://scenes/death_screen.tscn").instantiate()
		get_tree().current_scene.add_child(death_screen)
		death_screen.update_kills(kill_count)
		dead = true
		can_rotate = false
		
func pause():
	var pause_screen = preload("res://scenes/pause.tscn").instantiate()
	if Input.is_action_just_pressed("escape"):
		Engine.time_scale = 0
		#paused = true
		
		get_tree().current_scene.add_child(pause_screen)
		pause_screen.update_kills(kill_count)
		
	#if Input.is_action_just_pressed("return") and paused:
		#Engine.time_scale = 1
		#paused = false
		
		#pause_screen.queue_free()
		
func _physics_process(delta):
	movement()
	dash()
	camera()
	shoot()
	triple_shoot()
	melee()
	heal()
	trap()
	death()
	pause()

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

func _on_animated_sprite_2d_animation_finished():
	sprite.play("idle")
