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
	# TODO: maybe sort by temperature
	for reaction in reactions:
		var reaction_on_temperature_scale: ReactionOnTemperatureScale = reaction_on_temperature_scale_template.instantiate()
		add_child(reaction_on_temperature_scale)
		move_child(reaction_on_temperature_scale, 1)
		reaction_on_temperature_scale.set_reaction(reaction)
		reaction_on_temperature_scale.size_flags_vertical = Control.SIZE_EXPAND
		

func _process(delta: float) -> void:
	var last_obtained_reaction_temperature: float = 0.0
	for i in range(get_child_count()-1, -1, -1): # IMPORTANT! Get children in reverse order
		if get_child(i) is ReactionOnTemperatureScale:
			if get_child(i).reaction.temperature_threshold/max_temperature > 1.0 or get_child(i).reaction.temperature_threshold < max_temperature * 0.001:
				get_child(i).visible = false
			else:
				get_child(i).visible = true
				get_child(i).set_stretch_scale((get_child(i).reaction.temperature_threshold-last_obtained_reaction_temperature)/max_temperature)
				last_obtained_reaction_temperature = get_child(i).reaction.temperature_threshold
	# TODO: Fix scale
	empty_space.size_flags_stretch_ratio = (max_temperature - last_obtained_reaction_temperature)/max_temperature
	# empty_space.get_node("Label").text=str(floor(max_temperature - last_obtained_reaction_temperature))
	
func set_max_temperature(max_temp:float) -> void:
	max_temperature = max_temp