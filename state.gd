class_name State
extends Node

@export_category("Stats")
@export var move_speed : float = 5.0
@export var turn_speed : float = 0.005
@export_category("Permissions")
@export var can_move : bool
@export var can_shoot : bool
@export var can_aim : bool
@export var can_flash : bool

var parent : CharacterBody3D

func enter() -> void:
	pass

func exit() -> void:
	#Delete all child nodes created by state
	for child in get_children():
		child.queue_free()

#Called every frame
func state_input(event : InputEvent) -> State:
	return null
func state_process() -> State:
	return null
func state_physics(delta : float) -> State:
	return null
