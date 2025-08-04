extends Node

@export var default_state : State
@export var current_state : State

var parent : CharacterBody3D

func initialize(par : CharacterBody3D) -> void:
	#Store the reference to the parent
	parent = par
	
	#Store the reference to the parent in every state
	for child in get_children():
		child.parent = parent
	
	current_state = default_state
	
	#Default the label text
	parent.update_state_label()

func change_state(next_state : State) -> void:
	current_state.exit()
	next_state.enter()
	current_state = next_state
	parent.update_state_label()

#Called every frame
func state_input(event : InputEvent) -> void:
	#Store the return value of the current state's process function
	var next_state = current_state.state_input(event)
	#If the function returned a state, transition to that state
	if next_state != null:
		change_state(next_state)
func state_process() -> void:
	#Store the return value of the current state's process function
	var next_state = current_state.state_process()
	#If the function returned a state, transition to that state
	if next_state != null:
		change_state(next_state)
func state_physics(delta : float) -> void:
	#Store the return value of the current state's process function
	var next_state = current_state.state_physics(delta)
	#If the function returned a state, transition to that state
	if next_state != null:
		change_state(next_state)
