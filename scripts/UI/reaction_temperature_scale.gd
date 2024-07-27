class_name ReactionTemperatureScale

extends Control

var max_temperature: float
var reactions: Array[Reaction]
@onready var empty_space: Control = $EmptySpace
var reaction_on_temperature_scale_template: PackedScene = load("res://scenes/UI/reaction_on_temperature_scale.tscn")

func _ready() -> void:
	pass

func set_reactions(react: Array[Reaction]) -> void:
	reactions = react
	# construct reaction temperature scale
	var reverse_react = reactions.duplicate()
	reverse_react.reverse() # TODO: sort by temperature
	for reaction in reverse_react:
		var reaction_on_temperature_scale: ReactionOnTemperatureScale = reaction_on_temperature_scale_template.instantiate()
		add_child(reaction_on_temperature_scale)
		reaction_on_temperature_scale.set_reaction(reaction)
		reaction_on_temperature_scale.size_flags_vertical = Control.SIZE_EXPAND

func _process(delta: float) -> void:
	var last_obtained_reaction_temperature: float = 0.0
	for child in get_children():
		if child is ReactionOnTemperatureScale:
			if child.reaction.temperature_threshold/max_temperature >= 1.0 or child.reaction.temperature_threshold < max_temperature * 0.001:
				child.visible = false
			else:
				child.visible = true
				child.set_stretch_scale((child.reaction.temperature_threshold-last_obtained_reaction_temperature)/max_temperature)
				last_obtained_reaction_temperature = child.reaction.temperature_threshold
	# TODO: Fix scale
	empty_space.size_flags_stretch_ratio = (max_temperature - last_obtained_reaction_temperature)/max_temperature
	empty_space.get_node("Label").text=str(floor(max_temperature - last_obtained_reaction_temperature))
	
func set_max_temperature(max_temp:float) -> void:
	max_temperature = max_temp