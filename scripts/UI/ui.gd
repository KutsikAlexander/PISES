extends Node

@export var star: Star

@export var mass_label: Label
@export var temperature_label: Label
@export var isotope_menu: OptionButton
@export var mass_per_click_spin_box: SpinBox
@export var mass_scale: Container
var isotope_on_mass_scale: PackedScene = load("res://scenes/UI/isotope_on_mass_scale.tscn")
@export var temperature_scale: Container
@export var reactions_temperature_scale: Container
var reaction_on_temperature_scale: PackedScene = load("res://scenes/UI/reaction_on_temperature_scale.tscn")

func _ready() -> void:
	# construct isotope menu
	for isotope in Reaction.ISOTOPE.values():
		isotope_menu.add_item(Reaction.ISOTOPE.keys()[isotope])
		isotope_menu.set_item_disabled(isotope, true)
	isotope_menu.set_item_disabled(0, false)
	isotope_menu.select(0)

	# construct isotope mass scale
	for isotope in Reaction.ISOTOPE:
		mass_scale.add_child(isotope_on_mass_scale.instantiate())

	# construct reaction temperature scale
	for i in range(star.reactions.size()-1, -1, -1):
		var reaction: ReactionOnTemperatureScale = reaction_on_temperature_scale.instantiate()
		reactions_temperature_scale.add_child(reaction)
		reaction.name = "Reaction" + str(i+1)
		reaction.set_label(str(floor(star.reactions[i].temperature_threshold)))
		reaction.visible = false
	reactions_temperature_scale.get_node("EmptySpace").visible = true

func _process(delta: float) -> void:
	# activate new isotope
	for reaction:Reaction in star.reactions:
		if star.temperature > reaction.temperature_threshold:
			isotope_menu.set_item_disabled(reaction.product_isotope,false)

	# update labels
	var mass_text: String = ""
	for isotope in Reaction.ISOTOPE.values():
		if star.masses[isotope] > 0.0:
			mass_text += Reaction.ISOTOPE.keys()[isotope] + ":" + str(floor(star.masses[isotope])) + " Gg (" + str(floor(star.masses[isotope]/star.sum_masses()*100)) + "%) \n"
	mass_label.text = mass_text
	temperature_label.text = str(floor(star.temperature)) + " kK / " + str(floor(star.max_temperature)) + " kK"

	# mass scale
	for i in range(0, Reaction.ISOTOPE.size()):
		var relative_mass: float = star.masses[i]/star.sum_masses()
		if relative_mass > 0.01:
			mass_scale.get_child(i).visible = true
			mass_scale.get_child(i).size_flags_stretch_ratio = relative_mass
			mass_scale.get_child(i).tooltip_text = Reaction.ISOTOPE.keys()[i] + " " + str(floor(star.masses[i])) + " Gg"
			mass_scale.get_child(i).get_node("Label").text = Reaction.ISOTOPE.keys()[i] + " (" + str(floor(relative_mass*100)) + "%)"
		else:
			mass_scale.get_child(i).visible = false

	# temperature scale
	temperature_scale.get_node("EmptySpace").size_flags_stretch_ratio = (star.max_temperature-star.temperature)/star.max_temperature
	temperature_scale.get_node("CurrentTemperature").size_flags_stretch_ratio = star.temperature/star.max_temperature
	temperature_scale.get_node("CurrentTemperature/Label").text = str(floor(star.temperature)) + " kK"
	temperature_scale.get_node("CurrentTemperature").self_modulate = Color.from_hsv(star.temperature/star.max_temperature, 1.0, 1.0)

	#reactions temperature scale
	var max_obtained_reaction_temperature: float = 0.0
	for i in range(0, star.reactions.size()):
		if star.reactions[i].temperature_threshold/star.max_temperature > 1.0 or star.reactions[i].temperature_threshold < star.max_temperature * 0.001:
			reactions_temperature_scale.get_node("Reaction" + str(i+1)).visible = false
			continue
		else:
			reactions_temperature_scale.get_node("Reaction" + str(i+1)).visible = true
		if i == 0:
			reactions_temperature_scale.get_node("Reaction" + str(i+1)).set_stretch_scale(star.reactions[0].temperature_threshold/star.max_temperature)
		else:
			reactions_temperature_scale.get_node("Reaction" + str(i+1)).set_stretch_scale((star.reactions[i].temperature_threshold-star.reactions[i-1].temperature_threshold)/star.max_temperature)
		if star.reactions[i].temperature_threshold > max_obtained_reaction_temperature:
			max_obtained_reaction_temperature = star.reactions[i].temperature_threshold
	reactions_temperature_scale.get_node("EmptySpace").size_flags_stretch_ratio = (star.max_temperature - max_obtained_reaction_temperature)/star.max_temperature
