extends Node

class_name StatusService

const PlayerState = preload("res://src/enums/player_state.gd")

var player: CharacterBody3D


func _init(player_arg: CharacterBody3D):
	player = player_arg


func set_moving_state(direction: Vector3):
	if !player.is_on_floor():
		_change_state(PlayerState.Jumping)
	else:
		_change_state(PlayerState.Walking)


func set_idle_state():
	if !player.is_on_floor():
		_change_state(PlayerState.Jumping)
	else:
		_change_state(PlayerState.Idle)


func _change_state(new_state: int):
	if new_state != player.state:
		player.state = new_state
