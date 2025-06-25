class_name PlayerAirKickState
extends PlayerState

var has_attacked: bool
@onready var hitbox: Area2D = $Hitbox

func enter() -> void:
	super()
	if sprite_flipped: hitbox.scale.x = -1
	else: hitbox.scale.x = 1
	has_attacked = false
	player.animation.play(air_kick_anim)
	player.animation.animation_finished.connect(_on_animation_finished)

func exit(new_state: State = null) -> void:
	super(new_state)
	player.animation.animation_finished.disconnect(_on_animation_finished)
	if player:
		player.velocity.x = 0.0

func process_input(event: InputEvent) -> State:
	super(event)
	if has_attacked and event.is_action_pressed(movement_key):
		determine_sprite_flipped(event.as_text().get_slice(" (", 0))
	return null

func process_physics(delta: float) -> State:
	# Apply gravity to make the character fall
	if player:
		player.velocity.y += gravity * delta
		var move_dir: float = get_move_dir()
		do_move(move_dir)
		player.move_and_slide()
		if has_attacked:
			return fall_state
	return null

func get_move_dir() -> float:
	return Input.get_axis(left_key, right_key)

func do_move(move_dir: float) -> void:
	if player:
		player.velocity.x = move_dir * AIR_SPEED

func _on_animation_finished(_anim: String) -> void:
	has_attacked = true

const AIR_SPEED: float = 60.0
