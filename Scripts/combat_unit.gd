extends CharacterBody2D

const COMBO_WINDOW_TIME: float = 0.5 # seconds
const MAX_FORWARD_SPEED: float = 200.0 # pixels per second for lunge
const FORWARD_DISTANCE: float = 50.0 # pixels to move forward during attack
const ATTACK_DURATION: float = 0.3 # seconds per attack animation

var state: String = "IDLE"
var current_combo_button: String = ""
var combo_stage: int = 0
var combo_timer: float = 0.0
var lunge_progress: float = 0.0 # Tracks lunge animation (0 to 1)
var last_sprite_pos: Vector2 = Vector2.ZERO # For root motion

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	anim.animation_finished.connect(_on_animation_finished)
	last_sprite_pos = anim.position

func _physics_process(delta: float) -> void:
	if state == "ATTACKING":
		# Update lunge progress
		lunge_progress += delta / ATTACK_DURATION
		lunge_progress = clamp(lunge_progress, 0.0, 1.0)
		
		# Move sprite forward for visual lunge
		var target_pos_x: float = FORWARD_DISTANCE * lunge_progress
		anim.position.x = target_pos_x
		
		# Calculate velocity from sprite movement
		var current_sprite_pos: Vector2 = anim.position
		var sprite_delta: Vector2 = current_sprite_pos - last_sprite_pos
		last_sprite_pos = current_sprite_pos
		
		velocity.x = (sprite_delta.x / delta) if delta > 0 else 0.0
		velocity.x = clamp(velocity.x, -MAX_FORWARD_SPEED, MAX_FORWARD_SPEED)
		
		# Apply physics movement
		move_and_slide()
	else:
		velocity.x = 0.0
		if anim.position != Vector2.ZERO:
			anim.position = Vector2.ZERO
			last_sprite_pos = Vector2.ZERO
			lunge_progress = 0.0

func _process(delta: float) -> void:
	if state == "IDLE":
		if Input.is_action_just_pressed("attack_light"):
			start_attack("light")
		elif Input.is_action_just_pressed("attack_medium"):
			start_attack("medium")
		elif Input.is_action_just_pressed("attack_heavy"):
			start_attack("heavy")
	elif state == "COMBO_WINDOW":
		combo_timer -= delta
		if combo_timer <= 0:
			state = "IDLE"
			current_combo_button = ""
			combo_stage = 0
		else:
			if Input.is_action_just_pressed("attack_light"):
				handle_input("light")
			elif Input.is_action_just_pressed("attack_medium"):
				handle_input("medium")
			elif Input.is_action_just_pressed("attack_heavy"):
				handle_input("heavy")

func start_attack(button: String) -> void:
	current_combo_button = button
	combo_stage = 1
	play_attack_animation(button, combo_stage)
	state = "ATTACKING"
	lunge_progress = 0.0
	last_sprite_pos = anim.position

func handle_input(button: String) -> void:
	if button == current_combo_button and combo_stage < get_max_stages(current_combo_button):
		combo_stage += 1
		play_attack_animation(current_combo_button, combo_stage)
		state = "ATTACKING"
		lunge_progress = 0.0
		last_sprite_pos = anim.position
	elif button != current_combo_button:
		start_attack(button)
	combo_timer = COMBO_WINDOW_TIME

func play_attack_animation(button: String, stage: int) -> void:
	var anim_name: String = button + str(stage)
	if anim.sprite_frames.has_animation(anim_name):
		anim.play(anim_name)
	else:
		print("Animation not found: ", anim_name)
		state = "IDLE"

func _on_animation_finished() -> void:
	if state == "ATTACKING":
		state = "COMBO_WINDOW"
		combo_timer = COMBO_WINDOW_TIME
		anim.position = Vector2.ZERO
		last_sprite_pos = Vector2.ZERO
		lunge_progress = 0.0

func get_max_stages(button: String) -> int:
	match button:
		"light": return 3
		"medium": return 2
		"heavy": return 1
	return 0
