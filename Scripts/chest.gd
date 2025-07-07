extends Node2D

var player_in_area = false
var player = null

@export var item: InvItem
func _ready():
	# Connect the animation_finished signal to a function
	$AnimatedSprite2D.connect("animation_finished", _on_animated_sprite_2d_animation_finished)

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("Action"):
		$AnimatedSprite2D.play("Chest")

func drop_item():
	player.collect(item)

func _on_interaction_area_body_entered(body):
	if body.has_method("character"):
		player_in_area = true
		player = body

func _on_interaction_area_body_exited(body):
	if body.has_method("character"):
		player_in_area = false

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "Chest":
		drop_item()
		queue_free() # Delete the chest node
