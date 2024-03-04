extends CharacterBody2D

const SPEED = 300.0
const JUMP = -200.0
const GRAVITY = 700
const JUMP_VELOCITY = 50

enum State { Idle, Run, Jump }

var current_state

func _ready():
	current_state = State.Idle
	
func _physics_process(delta):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()
	
	player_animations()
	
	print("State: ",State.keys()[current_state])
	
func player_falling(delta):
	if !is_on_floor():
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
	if Input.is_action_just_pressed("jump"):
		current_state = State.Jump
		if is_on_floor():
			velocity.y = JUMP
		
		
	if !is_on_floor() and current_state == State.Jump:
		var direction = Input.get_axis("left", "right")
		velocity.x += direction * JUMP_VELOCITY * delta
		
func player_animations():
	if current_state == State.Idle:
		$AnimatedSprite2D.animation = "idle"
	elif current_state == State.Run:
		$AnimatedSprite2D.animation = "run"
	elif current_state == State.Jump:
		$AnimatedSprite2D.animation = "jump"


func _on_hurtbox_body_entered(body : Node2D):
	if body.is_in_group("Enemy"):
		print("Enemy entered")
