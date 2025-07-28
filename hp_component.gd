extends Node

@export var hurtbox : Area3D
@export var hp_label : Label3D
@export var max_hp : float = 100

var hp = max_hp

signal hp_depleted

func _ready() -> void:
	update_hp_label_text()

func update_hp_label_text():
	hp_label.text = "HP: " + str(hp)

func take_damage(damage : float):
	hp -= damage
	if hp < 0:
		hp = 0
		emit_signal("hp_depleted")
	
	update_hp_label_text()

#Connect hurtbox to this
func _on_hurtbox_area_entered(area: Area3D) -> void:
	take_damage(area.get_parent().get_damage())
