extends RigidBody3D

#Time until bullet automatically despawns
@export var lifetime_seconds : int = 3
@export var speed : int = 80

@onready var lifetime_timer = $Lifetime

#To be assigned by the gun spawning it
var direction : Vector3
var damage : float
var pierces : int
var start_pos : Vector3

func _ready() -> void:
	position = start_pos
	linear_velocity = transform.basis * Vector3(0, 0, -speed)
	#linear_velocity = direction * speed
	
	lifetime_timer.start(lifetime_seconds)

func _on_lifetime_timeout() -> void:
	destroy()

func get_damage() -> float:
	return damage

#Bullet makes contact with a target
func _on_hitbox_area_entered(area: Area3D) -> void:
	pierces -= 1
	if pierces <= 0:
		destroy()

func destroy():
	queue_free()
