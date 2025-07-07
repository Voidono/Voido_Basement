extends CharacterBody2D

@onready var anim = get_node("Flan/AnimatedSprite2D")
@onready var joystick = $Camera2D/Joystick
@onready var action = $Camera2D/Action_button

@export var inv: Inv

signal update_ui

var save_file_path = "res://Data/"
var save_file_name = "PlayerSave.tres"
var playerData = PlayerData.new()

var dir = 0 # Store the last direction outside the function
var Interact = false

func _ready():
	verify_save_directory(save_file_path)
	
func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func _physics_process(delta):
	var directionc  = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var directionp = joystick.posVector
	if directionc:
		velocity = directionc * playerData.speed
	elif directionp:
		velocity = directionp * playerData.speed
	else:
		velocity = Vector2(0,0)
		
	if Interact == true:
		pass
	
# Update the animation when the character is moving
	if velocity.length() > 0:
	# For pc
		if Input.is_action_pressed("move_right"):
			anim.play("Walk_Right")
			dir = 0  # Update the last direction to Right
		elif Input.is_action_pressed("move_left"):
			anim.play("Walk_Left")
			dir = 1  # Update the last direction to Left
		elif Input.is_action_pressed("move_up"):
			anim.play("Walk_Up")
			dir = 2  # Update the last direction to Up
		elif Input.is_action_pressed("move_down"):
			anim.play("Walk_Down")
			dir = 3  # Update the last direction to Down
	#For phone
		if joystick.posVector.x > 0.5 and abs(joystick.posVector.y) < 0.5:
			anim.play("Walk_Right")
			dir = 0  # Update the last direction to Right
		elif joystick.posVector.x < -0.5 and abs(joystick.posVector.y) < 0.5:
			anim.play("Walk_Left")
			dir = 1  # Update the last direction to Left
		elif joystick.posVector.y < -0.5 and abs(joystick.posVector.x) < 0.5:
			anim.play("Walk_Up")
			dir = 2  # Update the last direction to Up
		elif joystick.posVector.y > 0.5 and abs(joystick.posVector.x) < 0.5:
			anim.play("Walk_Down")
			dir = 3  # Update the last direction to Down


	# If the character is not moving, play the idle animation based on the last direction
	if velocity.length() == 0:
		match dir:
			0:
				anim.play("Idle_Right")
			1:
				anim.play("Idle_Left")
			2:
				anim.play("Idle_Up")
			3:
				anim.play("Idle_Down")
		
	move_and_slide()
func _process(delta):
	if Input.is_action_just_pressed("Save"):
		save()
		$"Save label".visible = true
		$"Load label".visible = false
	if Input.is_action_just_pressed("Load"):
		load_data()
		$"Load label".visible = true
		$"Save label".visible = false
	emit_signal("update_ui", playerData.health, self.position)
	playerData.UpdatePos(self.position)

func load_data():
	playerData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	on_start_load()
	print("loaded")

func on_start_load():
	self.position = playerData.SavePos

func save():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("save")

func collect(item):
	inv.insert(item)


func character():
	pass


func _on_button_button_down():
	Interact = true


func _on_button_button_up():
	Interact = false



func _on_soulbutton_button_down():
	pass # Replace with function body.


func _on_soulbutton_button_up():
	pass # Replace with function body.



		
