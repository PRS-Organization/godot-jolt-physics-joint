extends Panel

signal slider_changed(index: int, value: float)

@onready var label_base_value: Label = $GridContainer/LabelBaseValue
@onready var label_arm_value: Label = $GridContainer/LabelArmValue
@onready var label_wrist_value: Label = $GridContainer/LabelWristValue
@onready var label_claw_1_value: Label = $GridContainer/LabelClaw1Value
@onready var label_claw_2_value: Label = $GridContainer/LabelClaw2Value

func _on_h_slider_base_value_changed(value: float) -> void:
	label_base_value.text = str(value) + "°"
	slider_changed.emit(0, value)

func _on_h_slider_arm_value_changed(value: float) -> void:
	label_arm_value.text = str(value) + "°"
	slider_changed.emit(1, value)

func _on_h_slider_wrist_value_changed(value: float) -> void:
	label_wrist_value.text = str(value) + "°"
	slider_changed.emit(2, value)

func _on_h_slider_claw_1_value_changed(value: float) -> void:
	label_claw_1_value.text = str(value) + "°"
	slider_changed.emit(3, value)

func _on_h_slider_claw_2_value_changed(value: float) -> void:
	label_claw_2_value.text = str(value) + "°"
	slider_changed.emit(4, value)
