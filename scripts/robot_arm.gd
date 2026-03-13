extends Node3D

@onready var _joints: Array[Generic6DOFJoint3D] = [
	$Base2World, $Arm2Base, $Wrist2Arm, $Claw12Wrist, $Claw22Wrist
]

# Axial mapping：[Base(0), Arm(1), Wrist(2), Claw1(3), Claw2(4)]
var _joint_axes: Array[String] = ["y", "z", "y", "z", "z"] 

var motor_force_limit: float = 2000.0  
var spring_stiffness: float = 600.0    
var spring_damping: float = 80.0       
var move_speed: float = 5.0 

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	for i in _joints.size():
		_setup_jolt_servo(_joints[i], _joint_axes[i])

func _setup_jolt_servo(joint: Generic6DOFJoint3D, active_axis: String):
	# Lock linear displacement
	joint.set("linear_limit_x/enabled", true)
	joint.set("linear_limit_y/enabled", true)
	joint.set("linear_limit_z/enabled", true)
	
	for axis in ["x", "y", "z"]:
		if axis != active_axis:
			# Lock inactive axes
			joint.set("angular_limit_%s/enabled" % axis, true)
			joint.set("angular_limit_%s/lower_angle" % axis, 0.0)
			joint.set("angular_limit_%s/upper_angle" % axis, 0.0)
		else:
			# Configure the active axis: limit position -90 到 90
			joint.set("angular_limit_%s/enabled" % axis, true)
			joint.set("angular_limit_%s/lower_angle" % axis, deg_to_rad(-90.5))
			joint.set("angular_limit_%s/upper_angle" % axis, deg_to_rad(90.5))
			
			# Activate the motor and spring servo
			joint.set("angular_motor_%s/enabled" % axis, true)
			joint.set("angular_motor_%s/force_limit" % axis, motor_force_limit)
			
			joint.set("angular_spring_%s/enabled" % axis, true)
			joint.set("angular_spring_%s/stiffness" % axis, spring_stiffness)
			joint.set("angular_spring_%s/damping" % axis, spring_damping)
			joint.set("angular_spring_%s/equilibrium_point" % axis, 0.0)

func set_target_angle(index: int, radians: float, direction: float) -> void:
	if index >= _joints.size(): return
	var joint = _joints[index]
	var axis = _joint_axes[index]
	
	# Set the target location
	joint.set("angular_spring_%s/equilibrium_point" % axis, radians)
	# Set the moving speed
	joint.set("angular_motor_%s/target_velocity" % axis, direction * move_speed)

func get_joint_actual_angle(index: int) -> float:
	var joint = _joints[index]
	if joint.node_b.is_empty(): return 0.0
	var node_b = joint.get_node_or_null(joint.node_b) as RigidBody3D
	if not node_b: return 0.0
	
	# Get the local transformation of Node B relative to the Joint node to eliminate the interference from the parent node.
	var local_basis = (joint.global_transform.basis.inverse() * node_b.global_transform.basis).orthonormalized()
	var axis_str = _joint_axes[index]
	var angle = 0.0
	
	match axis_str:
		"x":
			# Rotate around the X-axis and observe the projection of the Y-axis onto the YZ plane.
			angle = atan2(local_basis.y.z, local_basis.y.y)
		"y":
			# Rotate around the Y-axis to see the projection of the X-axis onto the XZ plane
			angle = atan2(local_basis.x.z, local_basis.x.x)
		"z":
			# Rotate around the Z-axis and observe the projection of the X-axis onto the XY plane
			angle = atan2(local_basis.x.y, local_basis.x.x)
			
	return rad_to_deg(angle)
