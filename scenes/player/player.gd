extends CharacterBody3D

@export var speed := 8.0
@export var gravity := 75.0
@export var jump_force := 20.0

@onready var player_body = $Rig
@onready var animation_player = $AnimationPlayer
@onready var camera = $CamGimbalY

var angular_speed := 5.0


var target_velocity = Vector3.ZERO
var movement
var direction

func _physics_process(delta: float) -> void:
	move(delta)
	attack(delta)


func move(delta):
	
	movement = Input.get_vector("move_right","move_left","move_back","move_forward")
	#direction = (transform.basis * Vector3(movement.x, 0, movement.y)).normalized()
	direction= Vector3(movement.x, 0, movement.y).rotated(Vector3.UP, camera.rotation.y).normalized()
	
	if direction:
		animation_player.play("Running_A")
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		player_body.basis = Basis.looking_at(direction)
	else:
		animation_player.play("2H_Melee_Idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	if not is_on_floor():
		animation_player.play("Jump_Idle")
		velocity.y = velocity.y - (gravity * delta)
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		animation_player.play("Jump_Start")
		velocity.y = jump_force

		
	move_and_slide()


func attack(delta):
	if Input.is_action_just_pressed("attack"):
		animation_player.play("2H_Melee_Attack_Chop")
