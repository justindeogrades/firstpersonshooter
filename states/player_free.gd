extends PlayerState

@export var sprint_state : PlayerState
@export var sneak_state : PlayerState

func state_input(event : InputEvent) -> State:
	super(event)
	
	#Begin sprinting
	if event.is_action_pressed("sprint"):
		return sprint_state
	
	return null
