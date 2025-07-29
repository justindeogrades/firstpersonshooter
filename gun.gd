class_name Gun
extends Node3D

#Will use built-in name variable for now
#@export var name : String
#Storing bullet_path as a string for now
#@export var bullet : NodePath
@export var bullet_path : String = "res://bullet.tscn"
@export var bullet_parent : Node
@export var reload_timer : Timer
#Make sure One-shot is enabled on the cooldown timer
@export var cooldown_timer : Timer
@export var aim_ray : RayCast3D

@export var damage : float
@export var max_clip_ammo : int
@export var max_reserve_ammo : int
@export var reload_seconds : float
@export var cooldown_seconds : float
@export var hip_spray : float
@export var aim_spray : float
@export var bullets_per_shot : int = 1
@export var pierces : int = 1

var clip_ammo
var reserve_ammo

var aiming : bool = false
var aim_direction : Vector3

signal ammo_updated(reloading : bool)
#Obsolete signal, might delete
#signal reload_complete

#Assigned by parent
var parent : CharacterBody3D

func _ready() -> void:
	create_reload_timer()
	create_cooldown_timer()
	create_bullet_parent()
	create_aim_ray()
	
	clip_ammo = max_clip_ammo
	reserve_ammo = max_reserve_ammo

func _physics_process(delta: float) -> void:
	#Aim direction is now set by parent
	
	#Probably eliminating aim rays
	#if(aiming):
		#aim_ray.target_position = get_local_mouse_position()
	pass

func shoot():
	#Check for not reloading, not on cooldown, and has ammo
	if reload_timer.is_stopped() and cooldown_timer.is_stopped() and clip_ammo > 0:
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
		
		clip_ammo -= 1
		
		cooldown_timer.start(cooldown_seconds)
		
		ammo_updated.emit(false)

func reload() -> void:
	if reload_timer.is_stopped():
		reload_timer.start(reload_seconds)
		ammo_updated.emit(true)

func _on_reload_timer_timeout() -> void:
	
	var ammo_to_reload = max_clip_ammo - clip_ammo
		
	if ammo_to_reload > reserve_ammo:
		ammo_to_reload = reserve_ammo
		
	reserve_ammo -= ammo_to_reload
	clip_ammo += ammo_to_reload
	
	ammo_updated.emit(false)
	#reload_complete.emit()

#Will make this a static method at some point
func get_main() -> Node:
	return parent.get_parent()

#Now obsolete, get rid of this later
func create_bullet_parent():
	bullet_parent = Node.new()
	add_child(bullet_parent)

func create_reload_timer() -> void:
	reload_timer = Timer.new()
	reload_timer.one_shot = true
	reload_timer.timeout.connect(_on_reload_timer_timeout)
	add_child(reload_timer)

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
