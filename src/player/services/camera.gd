extends Node

class_name CameraService

var player: CharacterBody3D
var twist_pivot: Node3D
var pitch_pivot: Node3D
var twist_input := 0.0
var pitch_input := 0.0


func _init(
	player_arg: CharacterBody3D,
	twist_pivot_arg: Node3D,
	pitch_pivot_arg: Node3D,
):
	player = player_arg
	twist_pivot = twist_pivot_arg
	pitch_pivot = pitch_pivot_arg


func process(delta: float):
	_update_camera_movement()


func handle_camera_input(event: InputEvent):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = -event.relative.x * Application.MOUSE_SENSITIVITY
		pitch_input = -event.relative.y * Application.MOUSE_SENSITIVITY


func _update_camera_movement():
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		deg_to_rad(Application.MIN_CAMERA_ANGLE_X),
		deg_to_rad(Application.MAX_CAMERA_ANGLE_X)
	)

	twist_input = 0.0
	pitch_input = 0.0
