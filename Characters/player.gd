extends CharacterBody2D

class_name Player

signal healthChanged

var bullet = preload("res://fx/bullet.tscn")
@onready var muzzle : Marker2D = $Muzzle

@export var SPEED = 400.0
const GRAVITY = 700
@export var JUMP_HEIGHT = -500
@export var JUMP_VELOCITY = 400
@export var DOUBLE_JUMP = -400
@export var DOUBLE_JUMP_VELOCITY = 300
const AIR_SPEED = 50
const MAX_JUMP_TIME = 0.5

var can_double_jump = false

@export var maxHealth = 100
@onready var currentHealth: int = maxHealth
@onready var hurtTimer = $hurtTimer
@export var knockbackPower: int = 500

var isHurt: bool = false
var current_state
var muzzle_position

enum State { Idle, Run, Jump, DoubleJump, Shoot, Hurt }

func _ready():
	current_state = State.Idle
	muzzle_position = muzzle.position
	
func _physics_process(delta):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_shooting(delta)
	
	move_and_slide()
	
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

func player_jump(delta):
	var direction = Input.get_axis("left", "right")
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
		velocity.x = direction * JUMP_VELOCITY
		can_double_jump = true
		
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
		
func player_shooting(delta):
	if Input.is_action_just_pressed("shoot"):
		var direction = Input.get_axis("left", "right")
		# Press "Enter" key to shoot
		if direction != 0:
			var bullet_instance = bullet.instantiate() as Node2D
			bullet_instance.global_position = muzzle.global_position
			get_parent().add_child(bullet_instance)
			current_state = State.Shoot
		
func hurtbyVirus1(area):
	currentHealth -= 10  # Assuming damage amount is 10
	if currentHealth < 0:
		currentHealth = maxHealth

	current_state = State.Hurt
	isHurt = true
  # Emit signal after updating health
	healthChanged.emit()
	print("Player health:", currentHealth) #Print health after update
	
	knockback(area.get_parent().velocity)
	hurtTimer.start()
	await hurtTimer.timeout
	isHurt = false
	
func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
	
func player_animations():
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
	elif current_state == State.Hurt:
		pass
			

