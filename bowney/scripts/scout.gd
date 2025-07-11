extends CharacterBody2D

var speed = 150
var health = 5

#@onready var player = %player
var player = null
var attacking = false

func _ready():
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		player = players[0]

func _process(delta):
	if player:	
		var direction = (player.global_position - position).normalized()
		velocity = direction * speed
		rotation = direction.angle() + deg_to_rad(90)
		move_and_slide()
	
	if health <= 0:
		player.kill_count += 1
		print("kills: ", player.kill_count)
		queue_free()

	if not attacking:
		$AnimatedSprite2D.play("move")

func _on_hit_body_entered(body):
	if body.is_in_group("players"):
		body.health -= 2
		print("Player health:", body.health)
		$AnimatedSprite2D.play("attack")

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("move")
	
