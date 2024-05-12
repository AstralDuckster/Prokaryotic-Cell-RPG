extends CharacterBody2D

@export var player: Player

@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var gravity = 0
@export var friction := 10
@export var speed : float = 30.0

enum State { Idle }
var current_state
var damage_amount = 1

var is_movement_enabled: bool = true

var direction 
var knockback_dir
var knockback

func _ready():
	current_state = State.Idle
	
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
	current_state = State.Idle	
	
	if knockback == true:
		velocity.x = direction * -300
		knockback = false
	

func _on_player_knockback_to_enemy():
	var player_dir = get_parent().get_node("Player").dir
	knockback_dir = player_dir
	direction = knockback_dir * -1
	knockback = true
