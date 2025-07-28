extends CharacterBody3D

@onready var hp_label = $HP

@export var max_hp : float = 100

var current_hp = max_hp

#func _ready() -> void:
	#update_hp_label_text()
#
#func update_hp_label_text():
	#hp_label.text = "HP: " + str(current_hp)
#
#func take_damage(damage : float):
	#current_hp -= damage
	#if current_hp < 0:
		#current_hp = 0
	#update_hp_label_text()
#
#func _on_hurtbox_area_entered(area: Area3D) -> void:
	#take_damage(area.get_parent().get_damage())
