class_name PlayerFallState
extends PlayerState

const AIR_SPEED: float = 60.0
const JUMP_FORCE: float = 20.0  # Unused, kept for consistency

func enter() -> void:
	super()
	if player and player.animation:
		player.animation.play(fall_anim, -1, 2.0)

func exit(new_state: State = null) -> void:
	super(new_state)
	if player:
		player.velocity.x = 0.0

func process_input(event: InputEvent) -> State:
	super(event)
	if event.is_action_pressed(movement_key):
		determine_sprite_flipped(event.as_text().get_slice(" (", 0))
	if event.is_action_pressed(kick_key):
		return air_kick
	return null
	
func process_physics(delta: float) -> State: 
	var move_dir: float = get_move_dir()
	do_move(move_dir)
	if player:
		if player.is_on_floor():
			print("FallState: On floor, move_dir =", move_dir)
			if move_dir != 0.0:
				return walk_state
			else:
				return idle_state
		player.velocity.y += gravity * delta
		player.move_and_slide()
		print("FallState velocity:", player.velocity)
	return null

func get_move_dir() -> float:
	return Input.get_axis(left_key, right_key)

func do_move(move_dir: float) -> void:
	if player:
		player.velocity.x = move_dir * AIR_SPEED
