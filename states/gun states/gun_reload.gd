extends GunState

@export var free_state : GunState
@export var shoot_state : GunState

var reload_timer : Timer
var reload_seconds : float
var reload_complete : bool = false

func enter() -> void:
	reload_complete = false
	
	create_reload_timer()
	reload_timer.start(reload_seconds)

func state_process() -> GunState:
	if reload_complete:
		if Input.is_action_pressed("shoot"):
			return shoot_state
		return free_state
	return null

func create_reload_timer() -> void:
	reload_timer = Timer.new()
	reload_timer.one_shot = true
	reload_timer.timeout.connect(_on_reload_timer_timeout)
	add_child(reload_timer)

func _on_reload_timer_timeout() -> void:
	var ammo_to_reload = parent.max_clip_ammo - parent.clip_ammo
		
	if ammo_to_reload > parent.reserve_ammo:
		ammo_to_reload = parent.reserve_ammo
		
	parent.reserve_ammo -= ammo_to_reload
	parent.clip_ammo += ammo_to_reload
	
	parent.ammo_updated.emit(false)
	
	reload_complete = true
