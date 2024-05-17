extends CharacterBody2D

class_name Player

signal healthChanged
signal facing_direction_changed(facing_right: bool)
signal knockback_to_enemy
signal decrease_enemy_health

@export var SPEED = 400.0
const GRAVITY = 700
@export var JUMP_HEIGHT = -500
@export var JUMP_VELOCITY = 300
@export var DOUBLE_JUMP = -400
@export var DOUBLE_JUMP_VELOCITY = 150
@export var ATTACK_VELOCITY = 200.0
const AIR_SPEED = 50
const MAX_JUMP_TIME = 0.5

var can_double_jump = false
var attack_ip = false
var can_be_puffed = false

@export var maxHealth = 30
@onready var currentHealth: int = maxHealth

@onready var deal_attack_timer : Timer = $deal_attack_timer
@onready var hurtTimer = $hurtTimer
@export var knockbackPower: float = 500
var knockback_dir = Vector2()
var knockback_wait = -1
@export var dir = 1

var isHurt: bool = false
var current_state

enum State { Idle, Run, Jump, DoubleJump, Shoot, Attack1, Dead }

func _ready():
	current_state = State.Idle
		
func _physics_process(delta):
	move_and_slide()
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_attack(delta)
	
	
	player_animations()
	
	print("State: ",State.keys()[current_state])
	
func player_falling(delta):
	if is_on_floor():
		current_state = State.Idle
	else:
		velocity.y += GRAVITY * delta
		
func player_idle(delta):
	if is_on_floor():
		current_state = State.Idle

func player_run(delta):
	if !is_on_floor():
		return
		
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = SPEED * direction
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction != 0:
		current_state = State.Run
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D/fx.flip_h = velocity.x < 0
		
	if Input.is_action_pressed("right"):
		dir = 1
	if Input.is_action_pressed("left"):
		dir = -1
		
func player_jump(delta):
	var direction = Input.get_axis("left", "right")
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
		velocity.x = direction * JUMP_VELOCITY
		
	#Allows for small jump dependent on jump hold time
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_HEIGHT
			velocity.x = direction * JUMP_VELOCITY
			can_double_jump = true
			current_state = State.Jump
		elif !is_on_floor() and can_double_jump == true:
			velocity.y = DOUBLE_JUMP
			velocity.x = direction * DOUBLE_JUMP_VELOCITY
			current_state = State.DoubleJump
			can_double_jump = false

	#One way fall
	if Input.is_action_just_pressed("down") and is_on_floor():
		position.y += 2
		current_state = State.DoubleJump
			
func player_attack(delta):
	var direction = Input.get_axis("left", "right")
	emit_signal("facing_direction_changed", !$AnimatedSprite2D.flip_h)
	
	if Input.is_action_just_pressed("attack") and attack_ip == false: #attack is "M"
		velocity.x = direction * (SPEED - 200)
		attack_ip = true
		deal_attack_timer.start()
		current_state = State.Attack1
		
		for area in $Weapon.get_overlapping_areas():
			var parent = area.get_parent()
			print(parent.name)
			await get_tree().create_timer(0.4).timeout 
			emit_signal("knockback_to_enemy")
			emit_signal("decrease_enemy_health")
			
func _on_deal_attack_timer_timeout():
	attack_ip = false
	
func _on_hurtbox_body_entered(body : Node2D):
	var virus1_damage = 5
	if body.is_in_group("Enemy"):
		print("Virus_1 entered ")
		currentHealth -= virus1_damage
		if currentHealth < 0:
			pass
		
		healthChanged.emit()
		player_knockback()
		
		print_debug(currentHealth)
		
func _on_puff_timer_timeout():
	can_be_puffed = true
	
func _on_hurtbox_area_entered(area):
	var puff_damage = 5
	if area.is_in_group("Enemy_puff") and can_be_puffed == false:
		print("damage detected")
		
		currentHealth -= puff_damage
		healthChanged.emit()
		
	
func player_knockback():
	velocity.y -= knockbackPower * 0.2
	velocity.x -= knockbackPower * 1
	move_and_slide()


func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print_debug(collider.name)
	
		
func player_animations():
	if attack_ip == false:
		if current_state == State.Idle:
			$AnimatedSprite2D.animation = "idle"
		elif current_state == State.Run and $AnimatedSprite2D.animation != "run_shoot":
			$AnimatedSprite2D.animation = "run"
		elif current_state == State.Jump:
			$AnimatedSprite2D.animation = "tall_jump"
		elif current_state == State.DoubleJump:
			$AnimatedSprite2D.animation = "double_jump"
		elif current_state == State.Shoot:
			$AnimatedSprite2D.animation = "run_shoot"	
		elif current_state == State.Dead:
			$AnimationPlayer.play("faint")
	elif current_state == State.Attack1:
		$AnimationPlayer.play("attack1")

	









