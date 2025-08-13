extends GunState

@export var free_state : GunState
@export var reload_state : GunState

@export var damage : float
@export var cooldown_seconds : float
@export var hip_spray : float
@export var aim_spray : float
@export var bullets_per_shot : int = 1
@export var pierces : int = 1

var cooldown_timer : Timer = null

func enter() -> void:
	if cooldown_timer == null:
		create_cooldown_timer()

func state_input(event : InputEvent) -> GunState:
	#Stopping shooting
	if event.is_action_released("shoot"):
		return free_state
	#Reloading
	if event.is_action_pressed("reload"):
		return reload_state
	return null

func state_process() -> GunState:
	#Check for not reloading, not on cooldown, and has ammo
	if cooldown_timer.is_stopped() and parent.clip_ammo > 0:
		for i in bullets_per_shot:
			var bullet_instance = load(parent.bullet_path).instantiate()
			
			#Will return to spray patterns later
			#var spray_offset
			#if(aiming):
				#spray_offset = Vector2(randf_range(aim_spray * -1, aim_spray), randf_range(aim_spray * -1, aim_spray))
			#else:
				#spray_offset = Vector2(randf_range(hip_spray * -1, hip_spray), randf_range(hip_spray * -1, hip_spray))
			#bullet_instance.direction = (aim_direction + spray_offset).normalized()
			
			bullet_instance.direction = parent.aim_direction
			bullet_instance.damage = damage
			bullet_instance.pierces = pierces
			bullet_instance.start_pos = parent.global_position
			
			bullet_instance.transform.basis = parent.aim_ray.global_transform.basis
			
			#bullet_parent.add_child(bullet_instance)
			parent.get_main().add_child(bullet_instance)
		
		parent.clip_ammo -= 1
		
		cooldown_timer.start(cooldown_seconds)
		
		parent.ammo_updated.emit(false)
		
	return null

func create_cooldown_timer():
	cooldown_timer = Timer.new()
	#Oneshot must be enabled so timer stops when time expires
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
