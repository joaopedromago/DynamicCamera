extends Node

class_name AnimationService

const PlayerState = preload("res://src/enums/player_state.gd")

var player: CharacterBody3D
var animation_player: AnimationPlayer

var animation_played := false
var player_state := 0


func _init(player_arg: CharacterBody3D, animation_player_arg: AnimationPlayer):
	player = player_arg
	animation_player = animation_player_arg


func process(delta):
	_verify_state_changes()
	_animate()


func _animate():
	if !animation_played:
		animation_played = true
		match player_state:
			PlayerState.Jumping:
				animation_player.play("Jump_up")
	match player_state:
		PlayerState.Idle:
			animation_player.play("Idle")
		PlayerState.Walking:
			animation_player.play("Run_forward")


func _verify_state_changes():
	if player_state != player.state:
		player_state = player.state
		animation_played = false
