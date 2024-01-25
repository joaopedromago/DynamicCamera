extends Node3D

const PlayerState = preload("res://src/enums/player_state.gd")

@onready var player := $Player
@onready var playerStateLabel := $Control/PlayerState
@onready var fps_info := $Control/FpsInfo
@onready var fake_wall := $Objects/Walls/FakeWall
@onready var player_anti_collider := $Player/TwistPivot/PitchPivot/AntiCollider


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	player_anti_collider.add_excluded_object(fake_wall.get_rid())


func _process(delta):
	var state = player.state
	match state:
		PlayerState.Idle:
			playerStateLabel.text = "Idle"
		PlayerState.Walking:
			playerStateLabel.text = "Walking"
		PlayerState.Jumping:
			playerStateLabel.text = "Jumping"
	fps_info.text = str(Engine.get_frames_per_second()) + " fps"


func _on_side_scrolling_body_entered(body):
	if body.name == "Player":
		player.set_camera_side_scrolling()


func _on_third_person_body_entered(body):
	if body.name == "Player":
		player.set_camera_third_person()


func _on_isometric_body_entered(body):
	if body.name == "Player":
		player.set_camera_isometric()
