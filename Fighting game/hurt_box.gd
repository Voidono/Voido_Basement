class_name Hurtbox
extends Area2D

func _ready():
	collision_layer = 0
	collision_mask = 2
	self.area_entered.connect(on_area_entered)
func on_area_entered(hit_box: Hitbox) -> void:
	if hit_box == null: return
	#deal damage
	print("damage dealt")
	pass
