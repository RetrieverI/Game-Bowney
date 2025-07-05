extends CharacterBody2D

@onready var arrowscene = load("res://scenes/enemy_arrow.tscn")
#@onready var player = %player
@onready var cooldown_timer = $cooldown
var player = null

var speed = 200
var health = 10

var retreat = false
var stay = false
var cooldown = true
var attacking = false

func _ready():
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		player = players[0]

func _process(delta):
	if player:
		var direction = (player.global_position - position).normalized()
		rotation = direction.angle() + deg_to_rad(90)
		
		if retreat:
			velocity = -direction * speed	
		elif stay:
			velocity = Vector2.ZERO
		
			if cooldown:
				var arrow = arrowscene.instantiate()
				arrow.position = global_position
		
				var arrow_direction = (player.global_position - global_position).normalized()
				arrow.direction = direction
				arrow.rotation = direction.angle()
			
				get_tree().get_current_scene().add_child(arrow)
		
				cooldown = false
				cooldown_timer.start()
				
				$AnimatedSprite2D.play("attack")
				attacking =  true
			
		else:
			velocity = direction * speed
	
		move_and_slide()
	
	if health <= 0:
		player.kill_count += 1
		print("kills: ", player.kill_count)
		queue_free()
	
	if not attacking:
		$AnimatedSprite2D.play("move")
	
func _on_retreat_body_entered(body):
	if body.is_in_group("players"):
		retreat = true

func _on_stay_body_entered(body):
	if body.is_in_group("players"):
		stay = true

func _on_retreat_body_exited(body):
	if body.is_in_group("players"):
		retreat = false

func _on_stay_body_exited(body):
	if body.is_in_group("players"):
		stay = false

func _on_cooldown_timeout():
	cooldown = true

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("move")
