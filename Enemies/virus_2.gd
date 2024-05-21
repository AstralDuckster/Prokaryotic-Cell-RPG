extends CharacterBody2D

class_name Virus_2

signal healthChanged

@export var player: Player

@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var gravity = 100
@export var friction := 10
@export var speed : float = 30.0
@export var damage_amount  = 2

enum State { idle }
var current_state
@export var maxHealth = 50
@onready var currentHealth: int = maxHealth

var is_movement_enabled: bool = true

var direction 
var stun = false

func _ready():
	current_state = State.idle
	healthChanged.emit()
	
func _physics_process(delta):
	enemy_gravity(delta)
	enemy_idle(delta)

	if is_on_wall():
		starting_move_direction *= -1
	move_and_slide()
	
func enemy_gravity(delta):
	velocity.y += gravity 
	velocity.x = move_toward(velocity.x, 0, speed)
	
func enemy_idle(delta):
	current_state = State.idle	


func _on_detection_area_body_entered(body):
	pass # Replace with function body.



func _on_detection_area_body_exited(body):
	pass # Replace with function body.
