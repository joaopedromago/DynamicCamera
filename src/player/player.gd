extends CharacterBody3D

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
var twist_input := 0.0
var pitch_input := 0.0


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= Application.gravity * delta
	_update_camera_movement()
	_perform_jump()
	_perform_movement()
	move_and_slide()


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		_handle_camera_input(event)


func _perform_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = Application.JUMP_VELOCITY


func _perform_movement():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * Application.SPEED
		velocity.z = direction.z * Application.SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, Application.SPEED)
		velocity.z = move_toward(velocity.z, 0, Application.SPEED)


func _handle_camera_input(event: InputEvent):
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
