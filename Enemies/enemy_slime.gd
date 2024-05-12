extends CharacterBody2D

const GRAVITY = 100000
const SPEED = 1

enum State { Idle }
var current_state 
var direction : Vector2 = Vector2.LEFT
var damage_amount = 1

func _ready():
	current_state = State.Idle
	
func _physics_process(delta : float):
	enemy_gravity(delta)
	enemy_idle(delta)
	
	move_and_slide()
	
func enemy_gravity(delta : float):
	velocity.y += GRAVITY * delta	
	
func enemy_idle(delta : float):
	velocity.x += move_toward(velocity.x, 0, SPEED * delta)
	current_state = State.Idle
		
func _on_hurtbox_area_entered(area):
	print("Hurtbox area entered")
	
	if area.is_in_group("Player"):
		if area.has_method("take_damage"):
			area.take_damage(damage_amount)
		else:
			print("Error: 'take_damage' method not found on player")
