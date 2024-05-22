extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree

# Walks left by default
@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var movement_speed : float = 30.0
@export var hit_state : State
@export var damage_amount : int = 1

@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_wall():
		starting_move_direction *= -1

	# Will move if in a CharacterStateMachine State that allows movement
	var direction : Vector2 = starting_move_direction
	velocity.x = direction.x * movement_speed
	# Reduce movement if not in the hit state (hit state has it's only movement rules for knockback)

		
	move_and_slide()

func _on_hurtbox_area_entered(area):
	print("Hurtbox area entered")
	if area.is_in_group("Player"):
		if area.has_method("take_damage"):
			area.take_damage(damage_amount)
			velocity = Vector2.ZERO
		else:
			print("Error: 'take_damage' method not found on player")
