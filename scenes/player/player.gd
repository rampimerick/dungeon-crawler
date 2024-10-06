extends CharacterBody3D
class_name Player

var current_state := player_states.MOVE
enum player_states {MOVE, JUMP, ATTACK}


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

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		current_state = player_states.ATTACK
	if Input.is_action_just_pressed("jump"):
		current_state = player_states.JUMP

func _physics_process(delta: float) -> void:
	match current_state:
		player_states.MOVE:
			move(delta)
		player_states.ATTACK:
			attack()
		player_states.JUMP:
			jump()

func move(delta):
	movement = Input.get_vector("move_right","move_left","move_back","move_forward")
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
		
	move_and_slide()

func attack():
	animation_player.play("1H_Melee_Attack_Slice_Diagonal")
	await animation_player.animation_finished
	reset_state()	
	

func jump():
	if is_on_floor():
		animation_player.play("Jump_Start")
		velocity.y = jump_force
	reset_state()	

func reset_state():
	current_state = player_states.MOVE
