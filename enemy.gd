extends CharacterBody3D

@onready var hp_label = $HP

@export_category("Navigation")
@export var nav_agent : NavigationAgent3D
@export var target_path : NodePath
@export var deadzone : float = 3
@export_category("Stats")
@export var max_hp : float = 100
@export var move_speed : float = 4

var current_hp = max_hp

var target : CharacterBody3D

func _ready() -> void:
	target = get_node(target_path)

func _process(delat : float) -> void:
	nav_agent.set_target_position(target.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	var move_dir = (next_nav_point - global_position).normalized()
	
	#Move towards the player unless already within an acceptable distance
	if position.distance_to(target.position) > deadzone:
		velocity = move_dir * move_speed
	else:
		velocity = Vector3(0, 0, 0)
	
	move_and_slide()
	
