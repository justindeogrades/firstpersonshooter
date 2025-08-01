extends CharacterBody3D

const JUMP_VELOCITY = 4.5

@onready var hud = $HUD
#Will access this through a HUD script later
@onready var ammo_label = $HUD/Ammo
@onready var battery_label = $HUD/Battery

@export var head : Node3D
@export var camera : Camera3D
@export var flashlight : SpotLight3D
@export var move_speed : float = 5
@export var turn_speed : float = 0.005
@export var min_camera_x_rotation = -90
@export var max_camera_x_rotation = 90

var active_weapon : Gun

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Hardcode; fix later
	active_weapon = $Head/Camera3D/Weapons/MachineGun
	active_weapon.parent = self
	active_weapon.ammo_updated.connect(_on_active_weapon_ammo_updated)
	#active_weapon.reload_complete.connect(_on_active_weapon_reload_complete)
	
	flashlight.battery_updated.connect(_on_flashlight_battery_updated)
	
	update_ammo_label(false)
	update_battery_label()

func _unhandled_input(event: InputEvent) -> void:
	#Esc to free mouse from window
	if event.is_action_pressed("free_mouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion:
		#Im just taking bros word on ts i have no idea how this works
		#Horizontal rotation
		head.rotate_y(-event.relative.x * turn_speed)
		#Vertical rotation
		camera.rotate_x(-event.relative.y * (turn_speed / 2))
		#Limits on vertical rotation
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(min_camera_x_rotation), deg_to_rad(max_camera_x_rotation))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#Moving
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
	
	#Shooting
	active_weapon.aim_direction = (head.transform.basis * Vector3(0,0,-1)).normalized()
	if Input.is_action_pressed("shoot"):
		if active_weapon.reload_timer.is_stopped():
			active_weapon.shoot()
			#update_ammo_label(false)
	
	#Reloading
	if Input.is_action_just_pressed("reload"):
		active_weapon.reload()
		#update_ammo_label(true)
	
	#Toggle flashlight
	if Input.is_action_just_pressed("toggle_flashlight"):
		if flashlight.get_enabled():
			flashlight.set_enabled(false)
		else:
			flashlight.set_enabled(true)

	move_and_slide()

func update_ammo_label(reloading : bool):
	if reloading:
		ammo_label.text = "Reloading..."
	else:
		ammo_label.text = str(active_weapon.clip_ammo) + " / " + str(active_weapon.reserve_ammo)

func update_battery_label() -> void:
	battery_label.text = "Flashlight battery: " + str(int(flashlight.get_battery())) + "%"

func _on_active_weapon_ammo_updated(reloading : bool) -> void:
	update_ammo_label(reloading)

func _on_flashlight_battery_updated() -> void:
	update_battery_label()

#Obsolete
#func _on_active_weapon_reload_complete():
	#update_ammo_label(false)
