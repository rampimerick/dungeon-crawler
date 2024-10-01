extends CharacterBody3D

const SPEED = 8.0
const FALL_VELOCITY = 75

var target_velocity = Vector3.ZERO
var twist_input = 0.0
var pitch_input = 0.0
var camera_speed = 0.5

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
		

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		%AnimationPlayer.play("Running_A")
		$Rig.basis = Basis.looking_at(direction * -1)
	else:
		%AnimationPlayer.play("Idle")
	# Ground Velocity
	target_velocity.x = direction.x * SPEED
	target_velocity.z = direction.z * SPEED

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (FALL_VELOCITY * delta)

	# Moving the Character
	velocity = target_velocity
	
	move_and_slide()
