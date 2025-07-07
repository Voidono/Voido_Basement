extends CharacterBody2D

@onready var anim = get_node("Flan/AnimatedSprite2D")
@onready var joystick = $Camera2D/Joystick
@onready var action = $Camera2D/Action_button

@export var inv: Inv

var dir = 0 # Store the last direction outside the function
var Interact = false

func _physics_process(delta):
	var directionc  = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var directionp = joystick.posVector
	if directionc:
		velocity = directionc * 200
	elif directionp:
		velocity = directionp * 200
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
