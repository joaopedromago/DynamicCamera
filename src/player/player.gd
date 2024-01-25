extends CharacterBody3D

var CameraService = preload("res://src/player/services/camera.gd")
var MovementService = preload("res://src/player/services/movement.gd")
var AnimationService = preload("res://src/player/services/animation.gd")
var StatusService = preload("res://src/player/services/status.gd")

var camera_service: CameraService
var movement_service: MovementService
var animation_service: AnimationService
var status_service: StatusService

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var animation_player := $Body/Mesh/AnimationPlayer
@onready var body := $Body

const PlayerState = preload("res://src/enums/player_state.gd")
const CameraState = preload("res://src/enums/camera_state.gd")

var state := PlayerState.Idle
var camera_state := CameraState.ThirdPerson
var action_direction: Vector3

func _ready():	
	action_direction = rotation
	status_service = StatusService.new(self)
	animation_service = AnimationService.new(self, animation_player)
	movement_service = MovementService.new(self, body, status_service, twist_pivot, pitch_pivot)
	camera_service = CameraService.new(self, twist_pivot, pitch_pivot)

func _physics_process(delta):
	_handle_gravity(delta)
	camera_service.process(delta)
	movement_service.process(delta)
	animation_service.process(delta)
	move_and_slide()

func _handle_gravity(delta):
	if not is_on_floor():
		velocity.y -= Application.gravity * delta
	

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		camera_service.handle_camera_input(event)

func is_camera_locked():
	return camera_state != CameraState.ThirdPerson
