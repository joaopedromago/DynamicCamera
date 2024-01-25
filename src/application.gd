extends Node

const MOUSE_SENSITIVITY := 0.001

const MIN_CAMERA_ANGLE_X = -90
const MAX_CAMERA_ANGLE_X = 60
const DEFAULT_CAMERA_DISTANCE = 3

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
