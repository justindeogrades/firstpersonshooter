extends EnemyState

var deadzone : float = 2.0

func state_physics(delta : float) -> EnemyState:
	#Set the navigation target as the player
	nav_agent.set_target_position(parent.target.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	var move_dir = (next_nav_point - parent.global_position).normalized()
	parent.facing_ray.target_position = move_dir
	
	#Move towards the player unless already within an acceptable distance
	#if parent.position.distance_to(parent.target.global_position) > deadzone:
		#parent.velocity = move_dir * move_speed
	#else:
		#parent.velocity = Vector3(0, 0, 0)
	
	#Ignore deadzones, just move
	parent.velocity = move_dir * move_speed
	
	parent.move_and_slide()
	
	return null
