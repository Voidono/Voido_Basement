class_name PlayerState
extends State

@onready var player: Player = get_tree().get_first_node_in_group("Player")
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", -9.8)

#Animation name
var idle_anim: String = "Idle"
var walk_anim: String = "Walk"
var jump_anim: String = "Jump"
var fall_anim: String = "Fall"
var punch_anim: String = "Punch"
var kick_anim: String = "Kick"
var air_kick_anim: String ="Air_kick"
#States
@export_group("States")
@export var idle_state: PlayerState
@export var walk_state: PlayerState
@export var jump_state: PlayerState
@export var fall_state: PlayerState
@export var punch_state: PlayerState
@export var kick_state: PlayerState
@export var air_kick: PlayerState
#Sprite Variables
var sprite_flipped: bool = false
#Input Keys 
var movement_key: String = "Movement"
var left_key: String = "Left"
var right_key: String = "Right"
var jump_key: String = "Jump"
var punch_key: String = "Punch"
var kick_key: String = "Kick"
#Input action
var left_action: Array = InputMap.action_get_events(left_key).map(func(action: InputEvent) -> String: return action.as_text().get_slice(" (", 0))
var right_action: Array = InputMap.action_get_events(right_key).map(func(action: InputEvent) -> String: return action.as_text().get_slice(" (", 0))
#Util Fn
func determine_sprite_flipped(event_text: String) -> void:
	if left_action.find(event_text) != -1: sprite_flipped = true
	elif right_action.find(event_text) != -1: sprite_flipped = false
	player.sprite.flip_h = sprite_flipped
	pass
#Base Fn
func process_physics(delta:float) -> State:
	if(player.velocity.y > 0): return fall_state
	player.velocity.y += gravity * delta
	player.move_and_slide()
	return null

func exit (new_state: State = null) -> void:
	super()
	new_state.sprite_flipped = sprite_flipped
