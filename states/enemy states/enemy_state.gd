class_name EnemyState
extends State

var nav_agent : NavigationAgent3D

func enter() -> void:
	nav_agent = parent.nav_agent
	print("nav agent assigned: " + str(nav_agent))
