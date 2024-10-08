extends CharacterBody3D

@onready var animation := $AnimationPlayer
@onready var player := $"../Player"
@onready var skeleton_body := $Rig
@onready var hurtbox := $HurtBox/HurtBoxCollision

@export var speed := 5.0
@export var gravity := 75.0
@export var hp := 10

var current_state := states.PATROL
enum states {MOVE, ATTACK, PATROL, HURT}

func _physics_process(delta: float) -> void:
	match current_state:
		states.MOVE:
			move_or_idle(delta)
		states.ATTACK:
			attack()
		states.PATROL:
			patrol(delta)
		states.HURT:
			take_damage()


func move_or_idle(delta) -> void:
	var direction = global_position.direction_to(player.global_position);
	
	if direction:
		animation.play("Running_C")
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		skeleton_body.basis = Basis.looking_at(direction * -1)
	else:
		animation.play("Idle_B")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func attack() -> void:
	pass

func patrol(delta) -> void:
	animation.play("Idle_B")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		current_state = states.MOVE
	

func _on_detector_body_exited(body: Node3D) -> void:
	if body is Player:
		current_state = states.PATROL


func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area.is_in_group("Weapon"):
		current_state = states.HURT

func take_damage() -> void:
	if hp <= 0 :
		animation.play("Death_C_Skeletons")
		await animation.animation_finished
		queue_free()
	else:
		hp -= 1
		animation.play("Hit_B")
		await animation.animation_finished
	
	reset_state()

func reset_state() -> void:
	current_state = states.MOVE
