extends Node

class_name MovementService

var player: CharacterBody3D
var status_service: StatusService


func _init(player_arg: CharacterBody3D, status_service_arg: StatusService):
	player = player_arg
	status_service = status_service_arg


func process(delta: float):
	_perform_jump()
	_perform_movement()


func _perform_jump():
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = Application.JUMP_VELOCITY


func _perform_movement():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		status_service.set_moving_state()
		player.velocity.x = direction.x * Application.SPEED
		player.velocity.z = direction.z * Application.SPEED
	else:
		status_service.set_idle_state()
		player.velocity.x = move_toward(player.velocity.x, 0, Application.SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, Application.SPEED)
