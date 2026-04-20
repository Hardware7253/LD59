extends Camera2D

# Camera movement settings
@export var acceleration := 1000.0
@export var deceleration := 1000.0
@export var max_speed := 400.0

@export var max_zoom := 10
@export var camera_zoom_step := 0.5

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	position = get_viewport().get_visible_rect().size / 2

func _process(delta: float) -> void:
	var target_velocity = Vector2.ZERO

	# Zoom camera
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoom += Vector2(camera_zoom_step, camera_zoom_step)
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoom -= Vector2(camera_zoom_step, camera_zoom_step)
	zoom = zoom.clamp(Vector2.ONE, Vector2.ONE * max_zoom)

	# Get input for movement
	if Input.is_action_pressed("move_right"):
		target_velocity.x += 1
	if Input.is_action_pressed("move_left"):
		target_velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		target_velocity.y += 1
	if Input.is_action_pressed("move_up"):
		target_velocity.y -= 1

	# Normalize the target_velocity so the diagonal speed doesn't exceed max_speed
	if target_velocity.length() > 0:
		target_velocity = target_velocity.normalized() * max_speed

	# Accelerate / decelerate
	if velocity.length() < target_velocity.length():
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)

	# Apply the calculated velocity to the camera's position
	position += velocity * delta
