extends Node3D

@onready var robot = $Robot
@onready var ui = $UI 

var rotation_speed: float = 40.0 
var target_degrees: PackedFloat32Array = [0.0, 0.0, 0.0, 0.0, 0.0]

var key_map = [
	[KEY_U, KEY_I, 0], # Base
	[KEY_H, KEY_J, 1], # Arm
	[KEY_O, KEY_P, 2], # Wrist 
	[KEY_K, KEY_L, 3], # Claw1
	[KEY_N, KEY_M, 4]  # Claw2
]

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		target_degrees.fill(0.0)

	for config in key_map:
		var idx = config[2]
		var move_dir = 0.0
		
		if Input.is_key_pressed(config[0]): move_dir -= 1.0
		if Input.is_key_pressed(config[1]): move_dir += 1.0
		
		if move_dir != 0:
			target_degrees[idx] += move_dir * rotation_speed * delta
			target_degrees[idx] = clampf(target_degrees[idx], -90.0, 90.0)
		
		# Control commands are called in each frame.
		robot.set_target_angle(idx, deg_to_rad(target_degrees[idx]), move_dir)

	# Update UI
	if ui and ui.has_method("update_display"):
		var actuals: Array[float] = []
		for i in range(5):
			actuals.append(robot.get_joint_actual_angle(i))
		ui.update_display(actuals)
