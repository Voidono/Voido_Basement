class_name PlayerJumpState
extends PlayerState

const AIR_SPEED: float = 60.0
const JUMP_FORCE: float = -400.0  # Negative to move upward

func enter() -> void:
	super()
	if player and player.animation:
		player.animation.play(jump_anim, -1, 2.0)
	if player:
		player.velocity.y = JUMP_FORCE

func exit(new_state: State = null) -> void:
	super(new_state)
	if player:
		player.velocity.x = 0.0

func process_input(event: InputEvent) -> State:
	super(event)
	if event.is_action_pressed(movement_key):
		determine_sprite_flipped(event.as_text().get_slice(" (", 0))
	if event.is_action_released(jump_key):
		if player:
			player.velocity.y = 0
	if event.is_action_pressed(kick_key):
		return air_kick
	return null
	
func process_physics(delta: float) -> State: 
	super(delta)  # Apply gravity first
	var move_dir: float = get_move_dir()
	do_move(move_dir)
	if player and player.velocity.y > 0:
		return fall_state
	return null

func get_move_dir() -> float:
	return Input.get_axis(left_key, right_key)

func do_move(move_dir: float) -> void:
	if player:
		player.velocity.x = move_dir * AIR_SPEED
