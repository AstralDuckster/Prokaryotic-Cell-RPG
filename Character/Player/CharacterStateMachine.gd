extends Node

class_name CharacterStateMachine

@export var character : CharacterBody2D
@export var animation_tree : AnimationTree
@export var current_state : State

var states : Array[State]

func _ready():
	# Setup all child states under the CharacterStateMachine in the hierarchy
	# when the CharacterStateMachine loads in the scene
	for child in get_children():
		if(child is State):
			states.append(child)
			
			# Set the states up with what they need to function
			child.character = character
			child.playback = animation_tree["parameters/playback"]
			
			# Connect to interupt signal
			child.connect("interrupt_state", on_state_interrupt_state)
			
		else:
			push_warning("Child " + child.name + " is not a State for CharacterStateMachine")

func _physics_process(delta):
	if(current_state.next_state != null):
		switch_states(current_state.next_state)
		
	current_state.state_process(delta)

func check_if_can_move():
	return current_state.can_move

# Perform the current states exit tasks, change the state
# and then perform the new states enter tasks
func switch_states(new_state : State):
	if(current_state != null):
		current_state.on_exit()
		current_state.next_state = null
	
	current_state = new_state
	
	current_state.on_enter()

# Pass the player's input to the current state only
func _input(event : InputEvent):
	current_state.state_input(event)

# Respond to state interupt signals to immediate override the state to a new state
func on_state_interrupt_state(new_state : State):
	switch_states(new_state)
