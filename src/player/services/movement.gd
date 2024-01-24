extends Node

class_name MovementService

var player: CharacterBody3D
var status_service: StatusService
var twist_pivot: Node3D
var pitch_pivot: Node3D

func _init(player_arg: CharacterBody3D, status_service_arg: StatusService, twist_pivot_arg: Node3D, pitch_pivot_arg: Node3D):
	player = player_arg
	status_service = status_service_arg
	twist_pivot = twist_pivot_arg
	pitch_pivot = pitch_pivot_arg


func process(delta: float):
	_perform_jump()
	_perform_movement()

func _change_direction():
	if !player.get_meta("is_camera_locked"):
		var rotation = twist_pivot.rotation.y
		var distance = twist_pivot.get_child(0).get_child(0).spring_length
		
		var player_x = player.position.x
		var player_z = player.position.z
		
		var target_x = player_x + distance * cos(rotation)
		var target_z = player_z + distance * sin(rotation)
		
		var position = Vector3( target_x, player.position.y, target_z)
		#player.look_at(position)

func _perform_jump():
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = Application.JUMP_VELOCITY


func _perform_movement():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		_change_direction()	
		status_service.set_moving_state()
		player.velocity.x = direction.x * Application.SPEED
		player.velocity.z = direction.z * Application.SPEED
	else:
		status_service.set_idle_state()
		player.velocity.x = move_toward(player.velocity.x, 0, Application.SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, Application.SPEED)
