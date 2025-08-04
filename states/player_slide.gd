extends PlayerState

@export_category("State transitions")
@export var free_state : PlayerState
@export var sprint_state : PlayerState
@export_category("State specific stats")
@export var slide_seconds : float
#Obsolete
#@export var head_height_offset : float
@export var head_height_tween_seconds : float

var slide_timer : Timer
var slide_dir : Vector3
var slide_time_expired : bool

func enter() -> void:
	head_height_to_slide()
	
	#Direction is set upon entering so the slide direction cannot change once it starts
	slide_dir = parent.get_direction()
	
	slide_time_expired = false
	
	create_slide_timer()
	slide_timer.start(slide_seconds)

func exit() -> void:
	head_height_to_stand()

func state_physics(delta : float) -> PlayerState:
	super(delta)
	
	parent.velocity.x = slide_dir.x * move_speed
	parent.velocity.z = slide_dir.z * move_speed
	
	return null
func state_process() -> PlayerState:
	super()
	
	#Continue sprinting if sprint is still held, otherwise free
	if slide_time_expired:
		if Input.is_action_just_pressed("sprint"):
			return sprint_state
		else:
			return free_state
	return null

func head_height_to_slide() -> void:
	var head_pos_tween = create_tween()
	head_pos_tween.tween_property(parent.head, "position", parent.head_pos_sliding, head_height_tween_seconds)

func head_height_to_stand() -> void:
	var head_pos_tween = create_tween()
	head_pos_tween.tween_property(parent.head, "position", parent.head_pos_standing, head_height_tween_seconds)

func create_slide_timer() -> void:
	slide_timer = Timer.new()
	slide_timer.one_shot = true
	slide_timer.timeout.connect(_on_slide_timer_timeout)
	add_child(slide_timer)

func _on_slide_timer_timeout() -> void:
	slide_time_expired = true
	slide_timer.queue_free()
