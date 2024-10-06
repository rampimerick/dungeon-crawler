extends Node3D

var camera_speed := 4.0
@onready var camgimbalx := $CamGimbalX


func  _process(delta: float) -> void:
	if Input.is_action_pressed("camera_rotation_left"):
		rotation.y += camera_speed * delta
	if Input.is_action_pressed("camera_rotation_right"):
		rotation.y -= camera_speed * delta
	if Input.is_action_pressed("camera_rotation_up"):
		camgimbalx.rotation.x += camera_speed * delta
	if Input.is_action_pressed("camera_rotation_down"):
		camgimbalx.rotation.x -= camera_speed * delta
		
		
