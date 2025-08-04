class_name PlayerState
extends State

func state_input(event : InputEvent) -> State:
		#Esc to free mouse from window
	if event.is_action_pressed("free_mouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion:
		#Im just taking bros word on ts i have no idea how this works
		#Horizontal rotation
		parent.head.rotate_y(-event.relative.x * turn_speed)
		#Vertical rotation
		parent.camera.rotate_x(-event.relative.y * (turn_speed / 2))
		#Limits on vertical rotation
		parent.camera.rotation.x = clamp(parent.camera.rotation.x, deg_to_rad(parent.min_camera_x_rotation), deg_to_rad(parent.max_camera_x_rotation))
	return null
func state_process() -> State:
	super()
	
	#Shooting
	parent.active_weapon.aim_direction = (parent.head.transform.basis * Vector3(0,0,-1)).normalized()
	if Input.is_action_pressed("shoot"):
		if parent.active_weapon.reload_timer.is_stopped():
			parent.active_weapon.shoot()
			#update_ammo_label(false)
	
	#Reloading
	if Input.is_action_just_pressed("reload"):
		parent.active_weapon.reload()
		#update_ammo_label(true)
	
	#Toggle flashlight
	if Input.is_action_just_pressed("toggle_flashlight"):
		if parent.flashlight.get_enabled():
			parent.flashlight.set_enabled(false)
		else:
			parent.flashlight.set_enabled(true)
	
	return null
func state_physics(delta : float) -> State:
	super(delta)
	
	# Add the gravity.
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	
	#Only accept movement input if the state allows it
	if can_move:
		#Moving
		if Input.is_action_just_pressed("ui_accept") and parent.is_on_floor():
			parent.velocity.y = parent.JUMP_VELOCITY
		
		#Replaced by get_direction function
		#var input_dir := Input.get_vector("left", "right", "forward", "backward")
		#var direction : Vector3 = (parent.head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		var direction = parent.get_direction()
		if direction:
			parent.velocity.x = direction.x * move_speed
			parent.velocity.z = direction.z * move_speed
		else:
			parent.velocity.x = move_toward(parent.velocity.x, 0, move_speed)
			parent.velocity.z = move_toward(parent.velocity.z, 0, move_speed)
	
	parent.move_and_slide()
	
	return null
