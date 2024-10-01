extends Node3D

var camera_speed := 2.0


func  _process(delta: float) -> void:
	if Input.is_action_pressed("camera_rotation_left"):
		rotation.y += camera_speed * delta
	if Input.is_action_pressed("camera_rotation_right"):
		rotation.y -= camera_speed * delta
	if Input.is_action_pressed("camera_rotation_up"):
		rotation.x -= camera_speed * delta
	if Input.is_action_pressed("camera_rotation_down"):
		rotation.x += camera_speed * delta
		
		
