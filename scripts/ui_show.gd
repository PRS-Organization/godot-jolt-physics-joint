extends Panel


@onready var bars: Array[ProgressBar] = [
	$GridContainer/ProgressBarBase,
	$GridContainer/ProgressBarArm,
	$GridContainer/ProgressBarWrist,
	$GridContainer/ProgressBarClaw1,
	$GridContainer/ProgressBarClaw2
]

@onready var labels: Array[Label] = [
	$GridContainer/LabelBaseValue,
	$GridContainer/LabelArmValue,
	$GridContainer/LabelWristValue,
	$GridContainer/LabelClaw1Value,
	$GridContainer/LabelClaw2Value
]

func update_display(actual_angles: Array[float]) -> void:
	#print("UI Received: ", actual_angles)
	for i in range(actual_angles.size()):
		if i < bars.size() and bars[i]:
			# Limit the displayed value within the range of the progress bar
			bars[i].value = actual_angles[i]
			labels[i].text = "%.1f°" % actual_angles[i]
