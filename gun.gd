class_name Gun
extends Node3D

#Will use built-in name variable for now
#@export var name : String
#Storing bullet_path as a string for now
#@export var bullet : NodePath
@export var bullet_path : String = "res://bullet.tscn"
@export var bullet_parent : Node
#Make sure One-shot is enabled on the cooldown timer
@export var cooldown_timer : Timer
@export var aim_ray : RayCast3D

@export var damage : float
@export var cooldown_seconds : float
@export var hip_spray : float
@export var aim_spray : float
@export var bullets_per_shot : int = 1
@export var pierces : int = 1

var aiming : bool = false
var aim_direction : Vector3

#Assigned by parent
var parent : CharacterBody3D

func _ready() -> void:
	create_cooldown_timer()
	create_bullet_parent()
	create_aim_ray()

func _physics_process(delta: float) -> void:
	#Aim direction is now set by parent
	
	#Probably eliminating aim rays
	#if(aiming):
		#aim_ray.target_position = get_local_mouse_position()
	pass

func shoot():
	if(cooldown_timer.is_stopped()):
		#var bullet_instance = load(bullet).instantiate()
		
		for i in bullets_per_shot:
			var bullet_instance = load(bullet_path).instantiate()
			
			#Will return to spray patterns later
			#var spray_offset
			#if(aiming):
				#spray_offset = Vector2(randf_range(aim_spray * -1, aim_spray), randf_range(aim_spray * -1, aim_spray))
			#else:
				#spray_offset = Vector2(randf_range(hip_spray * -1, hip_spray), randf_range(hip_spray * -1, hip_spray))
			#bullet_instance.direction = (aim_direction + spray_offset).normalized()
			
			bullet_instance.direction = aim_direction
			bullet_instance.damage = damage
			bullet_instance.pierces = pierces
			bullet_instance.start_pos = global_position
			
			bullet_instance.transform.basis = aim_ray.global_transform.basis
			
			#bullet_parent.add_child(bullet_instance)
			get_main().add_child(bullet_instance)
		
		cooldown_timer.start(cooldown_seconds)

#Will make this a static method at some point
func get_main() -> Node:
	return parent.get_parent()

func create_bullet_parent():
	bullet_parent = Node.new()
	add_child(bullet_parent)

func create_cooldown_timer():
	cooldown_timer = Timer.new()
	#Oneshot must be enabled so timer stops when time expires
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)

func create_aim_ray():
	aim_ray = RayCast3D.new()
	#(0, 0, -1) is forward in 3D
	aim_ray.target_position = Vector3(0, 0, -1)
	add_child(aim_ray)
