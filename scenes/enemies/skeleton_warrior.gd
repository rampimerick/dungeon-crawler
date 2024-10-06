extends CharacterBody3D

@onready var animation := $AnimationPlayer
@onready var player := $"../Player"
@onready var body := $Rig

@export var speed := 5.0
@export var gravity := 75.0

var current_state := states.PATROL
enum states {MOVE, ATTACK, PATROL}

func _physics_process(delta: float) -> void:
	match current_state:
		states.MOVE:
			move_or_idle(delta)
		states.ATTACK:
			attack()
		states.PATROL:
			patrol(delta);


func move_or_idle(delta):
	var direction = global_position.direction_to(player.global_position);
	
	if direction:
		animation.play("Running_C")
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		body.basis = Basis.looking_at(direction * -1)
	else:
		animation.play("Idle_B")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func attack():
	pass

func patrol(delta):
	animation.play("Idle_B")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		current_state = states.MOVE
	


func _on_detector_body_exited(body: Node3D) -> void:
	if body is Player:
		current_state = states.PATROL
