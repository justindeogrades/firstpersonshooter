extends EnemyState

@export var pursue_state : EnemyState

@export var patrol_points : Array[Node3D]
#@export var deadzone : float = 0.9
@export var wait_seconds : float = 2.0
@export var detection_dist : float = 10.0

var wait_timer : Timer
var next_point : Node3D
var point_at : int = 0

func enter() -> void:
	super()
	create_wait_timer()
	set_next_point()
	print("enter method called")

func state_physics(delta : float) -> EnemyState:
	var next_nav_point = nav_agent.get_next_path_position()
	var move_dir = (next_nav_point - parent.global_position).normalized()
	parent.facing_ray.target_position = move_dir
	
	#Move towards the player unless already within an acceptable distance
	#if parent.position.distance_to(next_point.position) > deadzone:
		#parent.velocity = move_dir * move_speed
	#else:
		#parent.velocity = Vector3(0, 0, 0)
	#Move towards the target unless the wait timer is active
	if wait_timer.is_stopped():
		parent.velocity = move_dir * move_speed
	else:
		parent.velocity = Vector3(0, 0, 0)
	
	parent.move_and_slide()
	
	var dist_to_player = (parent.global_position - parent.target.global_position).length()
	
	#Detect player if within a 45 degree angle of facing direction and within detection distance
	if -22.5 < parent.angle_to_target and parent.angle_to_target < 22.5 and dist_to_player < detection_dist:
		return pursue_state
	
	return null

func set_next_point():
	point_at += 1
	if point_at >= patrol_points.size():
		point_at = 0
	next_point = patrol_points[point_at]
	nav_agent.set_target_position(next_point.global_position)

func create_wait_timer():
	wait_timer = Timer.new()
	wait_timer.one_shot = true
	wait_timer.timeout.connect(_on_wait_timer_timeout)
	add_child(wait_timer)

func _on_wait_timer_timeout() -> void:
	print("wait timer expired")
	set_next_point()

func _on_navigation_agent_3d_target_reached() -> void:
	print("target reached")
	wait_timer.start(wait_seconds)
