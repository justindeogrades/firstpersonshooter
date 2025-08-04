extends PlayerState

@export_category("State transitions")
@export var free_state : PlayerState
@export var slide_state : PlayerState
@export_category("State specific stats")
@export var grace_seconds : float

var grace_timer : Timer
var grace_period_expired : bool

func enter() -> void:
	grace_period_expired = false
	create_grace_timer()

func state_input(event : InputEvent) -> State:
	super(event)
	
	#Begin sprinting
	if event.is_action_released("sprint"):
		grace_timer.start(grace_seconds)
	if event.is_action_pressed("slide"):
		if not grace_timer.is_stopped():
			return slide_state
	
	return null

func state_process() -> State:
	super()
	
	if grace_period_expired:
		return free_state
	
	return null

func create_grace_timer() -> void:
	grace_timer = Timer.new()
	grace_timer.one_shot = true
	grace_timer.timeout.connect(_on_grace_timer_timeout)
	add_child(grace_timer)

func _on_grace_timer_timeout() -> void:
	grace_period_expired = true
	grace_timer.queue_free()
