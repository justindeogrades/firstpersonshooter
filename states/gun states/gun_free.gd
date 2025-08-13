extends GunState

@export var shoot_state : GunState
@export var reload_state : GunState

func state_input(event : InputEvent) -> GunState:
	if event.is_action_pressed("shoot"):
		return shoot_state
	if event.is_action_pressed("reload"):
		return reload_state
	return null
