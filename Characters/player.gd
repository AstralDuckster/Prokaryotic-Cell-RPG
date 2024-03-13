extends CharacterBody2D

var bullet = preload("res://fx/bullet.tscn")
@onready var muzzle : Marker2D = $Muzzle

const SPEED = 300.0
const JUMP = -500.0
const GRAVITY = 700
const JUMP_VELOCITY = 200
const DOUBLE_JUMP = -400
const DOUBLE_JUMP_VELOCITY = 70
const AIR_SPEED = 50

enum State { Idle, Run, Jump, DoubleJump, Shoot }

var current_state
var can_double_jump = false
var muzzle_position

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
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction != 0:
		current_state = State.Run
		$AnimatedSprite2D.flip_h = velocity.x < 0

func player_jump(delta):
	var direction = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() and (current_state == State.Idle or current_state == State.Run):
			velocity.y = JUMP
			velocity.x = direction * JUMP_VELOCITY
			current_state = State.Jump
			can_double_jump = true
			
		elif !is_on_floor() and can_double_jump == true:
			velocity.y = DOUBLE_JUMP
			velocity.x = direction * DOUBLE_JUMP_VELOCITY
			current_state = State.DoubleJump
			can_double_jump = false
			
func player_shooting(delta):
	if Input.is_action_just_pressed("shoot"):
		var direction = Input.get_axis("left", "right")
		# Press "Enter" key to shoot
		if direction != 0:
			var bullet_instance = bullet.instantiate() as Node2D
			bullet_instance.global_position = muzzle.global_position
			get_parent().add_child(bullet_instance)
			current_state = State.Shoot
	
func player_animations():
	if current_state == State.Idle:
		$AnimatedSprite2D.animation = "idle"
	elif current_state == State.Run and $AnimatedSprite2D.animation != "run_shoot":
		$AnimatedSprite2D.animation = "run"
	elif current_state == State.Jump:
		$AnimatedSprite2D.animation = "jump"
	elif current_state == State.DoubleJump:
		$AnimatedSprite2D.animation = "double_jump"
	elif current_state == State.Shoot:
		$AnimatedSprite2D.animation = "run_shoot"

			
func _on_hurtbox_body_entered(body : Node2D):
	if body.is_in_group("Enemy"):
		print("Enemy entered", body.damage_amount)
		HealthManager.decrease_health(body.damage_amount)


