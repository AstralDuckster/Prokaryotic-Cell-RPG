extends CharacterBody2D

class_name Virus_3

signal healthChanged

@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var gravity = 100
@export var friction := 10
@export var speed : float = 75.0
@export var damage_amount  = 2

enum State { idle }
var current_state
@export var maxHealth = 50
@onready var currentHealth: int = maxHealth

var is_movement_enabled: bool = true

var player_chase = false
var player = null
var animation_next = true

var direction 
var stun = false

func _ready():
	current_state = State.idle
	healthChanged.emit()
	
func _physics_process(delta):
	enemy_gravity(delta)
	enemy_idle(delta)
	
	if player_chase:
		position += (player.position - position)/speed
		$AnimationPlayer.play("attack")
		
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D2.flip_h = true
			
		else:
			$AnimatedSprite2D2.flip_h = false

	if is_on_wall():
		starting_move_direction *= -1
	move_and_slide()
	
func enemy_gravity(delta):
	velocity.y += gravity 
	velocity.x = move_toward(velocity.x, 0, speed)

func enemy_idle(delta):
	current_state = State.idle	

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player_chase = false
	$AnimationPlayer.queue("idle")


func _on_capture_area_body_entered(body):
	$AnimationPlayer.queue("idle")
