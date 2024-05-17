extends CharacterBody2D

class_name Virus_1

signal healthChanged

@export var player: Player

@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var gravity = 100
@export var friction := 10
@export var speed : float = 30.0
@export var damage_amount  = 10

enum State { Idle }
var current_state
@export var maxHealth = 30
@onready var currentHealth: int = maxHealth

var is_movement_enabled: bool = true

var direction 
var knockback_dir
var knockback
var can_puff = false


func _ready():
	current_state = State.Idle
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
	current_state = State.Idle	
	
	if knockback == true:
		velocity.x = direction * -300
		knockback = false
		
func _on_player_knockback_to_enemy():
	var player_dir = get_parent().get_node("Player").dir
	knockback_dir = player_dir
	direction = knockback_dir * -1
	knockback = true

func _on_player_decrease_enemy_health():
	var sword_damage = 10
	print("Virus_1 entered ")
	currentHealth -= sword_damage
	$AnimationPlayer.play("attacked")
	
	if currentHealth == 0:
		$death_timer.start()
		$AnimationPlayer.play("attack")	
		
	healthChanged.emit()
	print_debug(currentHealth)
	
func _on_death_timer_timeout():
	queue_free()

func _on_puff_timer_timeout():
	can_puff = true
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		print("Hurtbox area entered")
		$AnimationPlayer.play("attack")
		damage_amount -= HealthManager.max_health
		
func _on_area_2d_area_exited(area):
	if area.is_in_group("Player"):
		print("Player exited hurtbox area")
		$AnimatedSprite2D.play("idle") 



