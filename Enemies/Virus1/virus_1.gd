extends CharacterBody2D

@export var player: Player

@export var gravity = 0
@export var friction := 10
const SPEED = 1

enum State { Idle }
var current_state : State
var damage_amount = 1

var is_movement_enabled: bool = true

var direction = 1
var knockback_dir
var knockback

func _ready():
	current_state = State.Idle
	
func _physics_process(delta):
	enemy_gravity(delta)
	enemy_idle(delta)

	move_and_slide()
	
func enemy_gravity(delta):
	velocity.y += gravity 
	velocity.x = 0
	
func enemy_idle(delta):
	current_state = State.Idle	
		
	if knockback == true:
		velocity.x = knockback_dir * 700
		knockback = false
	

func _on_player_knockback_to_enemy():
	var player_dir = get_parent().get_node("Player").dir
	knockback_dir = player_dir
	direction = knockback_dir * -1
	knockback = true
