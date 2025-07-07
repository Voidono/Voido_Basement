extends Control

@onready var inv: Inv = preload("res://Inventory/Item/Player_inv1.tres")
@onready var slots: Array = $Inv_slot/Inv_slot_container.get_children()

var is_open = false 

func _ready():
	inv.update.connect(update_slots)
	update_slots()

#update the texture in item slots
func update_slots(): 
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])


func _process(delta):
	if Input.is_action_just_pressed("m"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false


func _on_button_button_down():
		get_tree().change_scene_to_file("res://Scene/map test.tscn")
