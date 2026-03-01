#Copyright © 2022 Marc Nahr: https://github.com/MarcPhi/godot-free-look-camera
extends Camera3D

const HALF_PI := PI / 2.0

@export_range(0,   10, 0.01) var sensitivity: float = 3.0
@export_range(0, 1000, 0.10) var default_velocity: float = 5.0
@export_range(0,   10, 0.01) var speed_scale: float = 1.17
@export_range(1,  100, 0.10) var boost_speed_multiplier: float = 3.0
@export var max_speed: float = 1000.0
@export var min_speed: float = 0.2

@onready var _velocity := default_velocity

func _input(event: InputEvent) -> void:
	if not current:
		return

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotation.y -= event.relative.x / 1000.0 * sensitivity
			rotation.x -= event.relative.y / 1000.0 * sensitivity
			rotation.x = clamp(rotation.x, -HALF_PI, HALF_PI)

	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)
			MOUSE_BUTTON_WHEEL_UP: # increase fly velocity
				_velocity = clampf(_velocity * speed_scale, min_speed, max_speed)
			MOUSE_BUTTON_WHEEL_DOWN: # decrease fly velocity
				_velocity = clampf(_velocity / speed_scale, min_speed, max_speed)

func _process(delta: float) -> void:
	if not current:
		return

	var direction := Vector3(
		float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A)),
		float(Input.is_physical_key_pressed(KEY_E)) - float(Input.is_physical_key_pressed(KEY_Q)),
		float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W))
	).normalized()

	var boost := boost_speed_multiplier if Input.is_physical_key_pressed(KEY_SHIFT) else 1.0
	translate(direction * _velocity * delta * boost)
