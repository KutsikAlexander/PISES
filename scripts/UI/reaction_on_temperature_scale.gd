class_name ReactionOnTemperatureScale

extends Control

@onready var label: Label = $Label

func set_label(text: String) -> void:
	label.text = text

func set_stretch_scale(stretch_scale: float) -> void:
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	size_flags_stretch_ratio = stretch_scale
