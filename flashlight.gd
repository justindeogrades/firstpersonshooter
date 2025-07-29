extends SpotLight3D

const MAX_BATTERY : float = 100

#Drain per frame
@export var battery_drain : float = 0.1

var enabled : bool = false
var battery : float = MAX_BATTERY

signal battery_updated

func _process(delta: float) -> void:
	if enabled:
		battery -= battery_drain
		if battery <= 0:
			battery = 0
			set_enabled(false)
		
		battery_updated.emit()

func get_battery() -> float:
	return battery

func get_enabled() -> bool:
	return enabled

func set_enabled(to_enable : bool) -> void:
	if to_enable:
		enabled = true
		visible = true
	else:
		enabled = false
		visible = false
