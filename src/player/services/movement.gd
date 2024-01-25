extends Node

class_name MovementService

const PlayerState = preload("res://src/enums/player_state.gd")

var player: CharacterBody3D
var status_service: StatusService
var twist_pivot: Node3D
var pitch_pivot: Node3D
var player_body: CollisionShape3D


func _init(
	player_arg: CharacterBody3D,
	player_body_arg: CollisionShape3D,
	status_service_arg: StatusService,
	twist_pivot_arg: Node3D,
	pitch_pivot_arg: Node3D
):
	player = player_arg
	player_body = player_body_arg
	status_service = status_service_arg
	twist_pivot = twist_pivot_arg
	pitch_pivot = pitch_pivot_arg


func process(delta: float):
	_change_direction()
	_perform_jump()
	_perform_movement()


func _change_direction():
	var rotation_y = twist_pivot.rotation.y
	player.action_direction = Vector3(player.rotation.x, rotation_y, player.rotation.z)


func _perform_jump():
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = Application.JUMP_VELOCITY


func _perform_movement():
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var input_direction := Vector3(input_dir.x, 0, input_dir.y)

	if input_direction:
		_face_direction(input_direction)
		status_service.set_moving_state(input_direction)
		var velocity_x = input_direction.x * Application.SPEED
		var velocity_z = input_direction.z * Application.SPEED
		var move_direction = twist_pivot.global_transform.basis

		player.velocity = (move_direction * Vector3(velocity_x, player.velocity.y, velocity_z))
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, Application.SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, Application.SPEED)
		status_service.set_idle_state()


func _face_direction(direction: Vector3):
	var direction_x = direction.x * player.action_direction.y * -1
	var direction_z = direction.z * player.action_direction.y * -1

	if player.action_direction.y > 0:
		player_body.rotation.y = atan2(direction_x, direction_z) + player.action_direction.y
	elif player.action_direction.y == 0:
		player_body.rotation.y = atan2(direction.x * -1, direction.z * -1)
	else:
		var normalized_direction = player.action_direction.y - deg_to_rad(180)
		player_body.rotation.y = atan2(direction_x, direction_z) + normalized_direction
