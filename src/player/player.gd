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
@onready var animation_player := $Mesh/AnimationPlayer


func _ready():
	status_service = StatusService.new(self)
	animation_service = AnimationService.new(self, animation_player)
	camera_service = CameraService.new(self, twist_pivot, pitch_pivot)
	movement_service = MovementService.new(self, status_service)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= Application.gravity * delta
	camera_service.process(delta)
	movement_service.process(delta)
	animation_service.process(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		camera_service.handle_camera_input(event)
