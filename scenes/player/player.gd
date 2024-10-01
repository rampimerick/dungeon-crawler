extends CharacterBody3D

@export var speed := 8.0
@export var gravity := 75.0
@export var jump_force := 7.0

@onready var player_body = $Rig
var angular_speed := 5.0


var target_velocity = Vector3.ZERO
var movement
var direction

func _physics_process(delta: float) -> void:
	move(delta)


func move(delta):
	
	movement = Input.get_vector("move_right","move_left","move_back","move_forward")
	direction = (transform.basis * Vector3(movement.x, 0, movement.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		player_body.basis = Basis.looking_at(direction)
		%AnimationPlayer.play("Running_A")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	if not is_on_floor():
		velocity.y = velocity.y - (gravity * delta)
		%AnimationPlayer.play("Jump_Idle")
		
	move_and_slide()
