class_name ReactionOnTemperatureScale

extends Control

var reaction: Reaction
@onready var label: Label = $Label

func set_reaction(react: Reaction) -> void:
	reaction = react
	label.text = str(floor(reaction.temperature_threshold))
	label.tooltip_text = reaction.reaction_name # or reaction.description

func set_stretch_scale(stretch_scale: float) -> void:
	size_flags_stretch_ratio = stretch_scale
