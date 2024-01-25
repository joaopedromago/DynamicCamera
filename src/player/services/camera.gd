extends Node

class_name CameraService

const PlayerState = preload("res://src/enums/player_state.gd")

var player: CharacterBody3D
var twist_pivot: Node3D
var pitch_pivot: Node3D
var camera_anti_collider: SpringArm3D
var twist_input := 0.0
var pitch_input := 0.0


func _init(
	player_arg: CharacterBody3D,
	twist_pivot_arg: Node3D,
	pitch_pivot_arg: Node3D,
	camera_anti_collider_arg: SpringArm3D
):
	player = player_arg
	twist_pivot = twist_pivot_arg
	pitch_pivot = pitch_pivot_arg
	camera_anti_collider = camera_anti_collider_arg


func process(delta: float):
	_update_camera_movement()


func handle_camera_input(event: InputEvent):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and !player.is_camera_movement_blocked():
		twist_input = -event.relative.x * Application.MOUSE_SENSITIVITY
		pitch_input = -event.relative.y * Application.MOUSE_SENSITIVITY


func _update_camera_movement():
	if player.is_camera_movement_blocked():
		return
		
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		deg_to_rad(Application.MIN_CAMERA_ANGLE_X),
		deg_to_rad(Application.MAX_CAMERA_ANGLE_X)
	)

	twist_input = 0.0
	pitch_input = 0.0

func reset_camera_config():
	camera_anti_collider.spring_length = Application.DEFAULT_CAMERA_DISTANCE
	twist_pivot.rotation = Vector3(0, 0, 0)
	pitch_pivot.rotation = Vector3(0, 0, 0)
	twist_input = 0.0
	pitch_input = 0.0

func set_side_scrolling_config():
	reset_camera_config()
	camera_anti_collider.spring_length = Application.DEFAULT_CAMERA_DISTANCE * 2
	pitch_pivot.rotate_x(deg_to_rad(-15))
	
func set_third_person_config():
	reset_camera_config()
	print("set_third_person_config")
	
func set_isometric_config():
	reset_camera_config()
	camera_anti_collider.spring_length = Application.DEFAULT_CAMERA_DISTANCE * 2
	pitch_pivot.rotate_x(deg_to_rad(-80))
	
	
func set_first_person_config():
	reset_camera_config()
	print("set_first_person_config")
	
