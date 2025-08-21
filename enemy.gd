extends CharacterBody3D

@onready var hp_label = $HP
@onready var state_machine = $StateMachine
@onready var facing_ray = $FacingRay

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
	state_machine.initialize(self)

func _process(delat : float) -> void:
	
	#Temporarily disabling movement
	#nav_agent.set_target_position(target.global_position)
	#var next_nav_point = nav_agent.get_next_path_position()
	#var move_dir = (next_nav_point - global_position).normalized()
	#
	##Move towards the player unless already within an acceptable distance
	#if position.distance_to(target.position) > deadzone:
		#velocity = move_dir * move_speed
	#else:
		#velocity = Vector3(0, 0, 0)
	#
	#move_and_slide()
	
	#Get angle between player and ray
	var face_dir = Vector2(facing_ray.target_position.x, facing_ray.target_position.z).normalized()
	#var target_dir = Vector2(target.global_position.x, target.global_position.z)
	var relative_player_pos = Vector2(target.global_position.x - global_position.x, target.global_position.z - global_position.z)
	#var angle = int(rad_to_deg(face_dir.angle_to(target_dir)))
	var angle = int(rad_to_deg(face_dir.angle_to(relative_player_pos)))
	$Angle.text = "angle: " + str(angle)
func _physics_process(delta: float) -> void:
	state_machine.state_physics(delta)
