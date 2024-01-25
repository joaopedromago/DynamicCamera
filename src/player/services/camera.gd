extends Node

class_name CameraService

const PlayerState = preload("res://src/enums/player_state.gd")
const CameraState = preload("res://src/enums/camera_state.gd")

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
	_handle_camera_perspective()


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


func _reset_camera_config():
	camera_anti_collider.position = Vector3(0, 0, 0)
	camera_anti_collider.spring_length = Application.DEFAULT_CAMERA_DISTANCE
	twist_pivot.rotation = Vector3(0, 0, 0)
	pitch_pivot.rotation = Vector3(0, 0, 0)
	twist_input = 0.0
	pitch_input = 0.0


func _handle_camera_perspective():		
	match player.camera_state:
		CameraState.SideScrolling:
			_set_side_scrolling_config()
		CameraState.Isometric:
			_set_isometric_config()
		CameraState.ThirdPerson:
			_set_third_person_config()
		CameraState.FirstPerson:
			_set_first_person_config()


func _set_side_scrolling_config():
	_update_camera_perspective(Application.DEFAULT_CAMERA_DISTANCE * 2, Vector3(0, 0, 0), deg_to_rad(-15), deg_to_rad(0))


func _set_third_person_config():
	_update_camera_perspective(Application.DEFAULT_CAMERA_DISTANCE, Vector3(0, 0, 0))


func _set_isometric_config():
	_update_camera_perspective(Application.DEFAULT_CAMERA_DISTANCE * 2, Vector3(0, 0, 0), deg_to_rad(-80), deg_to_rad(0))


func _set_first_person_config():
	_update_camera_perspective(0, Vector3(0, 0.75, 0), null, player.action_direction.y)


func _update_camera_perspective(
	spring_length = null,
	spring_position = null,
	pitch_rotation_x = null,
	twist_rotation_y = null
):
	if spring_length != null:
		_update_spring_length(spring_length)
	if spring_position != null:
		_update_spring_position(spring_position)
	if pitch_rotation_x != null:
		_update_pitch_rotation_x(pitch_rotation_x)
	if twist_rotation_y != null:
		_update_twist_rotation_y(twist_rotation_y)


func _update_spring_length(spring_length: float):
	if camera_anti_collider.spring_length > spring_length:
		camera_anti_collider.spring_length = clampf(camera_anti_collider.spring_length - 0.1, spring_length, camera_anti_collider.spring_length)
	elif camera_anti_collider.spring_length < spring_length:
		camera_anti_collider.spring_length = clampf(camera_anti_collider.spring_length + 0.1, camera_anti_collider.spring_length, spring_length)


func _update_spring_position(spring_position: Vector3):
	if camera_anti_collider.position.x > spring_position.x:
		camera_anti_collider.position.x = clampf(camera_anti_collider.position.x - 0.05, spring_position.x, camera_anti_collider.position.x)
	elif camera_anti_collider.position.x < spring_position.x:
		camera_anti_collider.position.x = clampf(camera_anti_collider.position.x + 0.05, camera_anti_collider.position.x, spring_position.x)
	if camera_anti_collider.position.y > spring_position.y:
		camera_anti_collider.position.y = clampf(camera_anti_collider.position.y - 0.05, spring_position.x, camera_anti_collider.position.y)
	elif camera_anti_collider.position.y < spring_position.y:
		camera_anti_collider.position.y = clampf(camera_anti_collider.position.y + 0.05, camera_anti_collider.position.y, spring_position.y)
	if camera_anti_collider.position.z > spring_position.z:
		camera_anti_collider.position.z = clampf(camera_anti_collider.position.z - 0.05, spring_position.x, camera_anti_collider.position.z)
	elif camera_anti_collider.position.z < spring_position.z:
		camera_anti_collider.position.z = clampf(camera_anti_collider.position.z + 0.05, camera_anti_collider.position.z, spring_position.z)


func _update_pitch_rotation_x(pitch_rotation_x: float):	
	if pitch_pivot.rotation.x > pitch_rotation_x:
		pitch_pivot.rotation.x = clampf(pitch_pivot.rotation.x - 0.01, pitch_rotation_x, pitch_pivot.rotation.x)
	elif pitch_pivot.rotation.x < pitch_rotation_x:
		pitch_pivot.rotation.x = clampf(pitch_pivot.rotation.x + 0.01, pitch_pivot.rotation.x, pitch_rotation_x)

func _update_twist_rotation_y(twist_rotation_y: float):	
	if twist_pivot.rotation.y > twist_rotation_y:
		twist_pivot.rotation.y = clampf(twist_pivot.rotation.y - 0.01, twist_rotation_y, twist_pivot.rotation.y)
	elif twist_pivot.rotation.y < twist_rotation_y:
		twist_pivot.rotation.y = clampf(twist_pivot.rotation.y + 0.05, twist_pivot.rotation.y, twist_rotation_y)

# TODO: reduce transition time by distance
