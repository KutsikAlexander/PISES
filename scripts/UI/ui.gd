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
@export var game_over_windows: Container
@export var reason_label: Label

func _ready() -> void:
	# hide game over windows
	game_over_windows.visible = false

	# construct isotope menu
	for i: int in range(0, star.isotopes.size()):
		isotope_menu.add_item(star.isotopes[i].name)
		isotope_menu.set_item_disabled(i, true)
	isotope_menu.set_item_disabled(0, false)
	isotope_menu.select(0)

	# construct isotope mass scale
	for isotope in star.isotopes:
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
		if star.temperature > reaction.temperature_threshold or star.sum_masses() > reaction.mass_threshold:
			for isotope in reaction.output_chanel.isotopes:
				for i in range(0, star.isotopes.size()):
					if star.isotopes[i] == isotope:
						isotope_menu.set_item_disabled(i,false)
						break

	# update labels
	var mass_text: String = ""
	for isotope in star.isotopes:
		if star.masses[isotope.name] > 0.0:
			mass_text += isotope.name + ":" + str(floor(star.masses[isotope.name])) + " Gg (" + str(floor(star.masses[isotope.name]/star.sum_masses()*100)) + "%) \n"
	mass_label.text = mass_text
	temperature_label.text = str(floor(star.temperature)) + " MK / " + str(floor(star.max_temperature)) + " MK"

	# mass scale
	for i in range(0, star.isotopes.size()):
		var relative_mass: float = star.masses[star.isotopes[i].name]/star.sum_masses()
		if relative_mass > 0.01:
			mass_scale.get_child(i).visible = true
			mass_scale.get_child(i).size_flags_stretch_ratio = relative_mass
			mass_scale.get_child(i).tooltip_text = star.isotopes[i].name + " " + str(floor(star.masses[star.isotopes[i].name])) + " Gg"
			mass_scale.get_child(i).get_node("Label").text = star.isotopes[i].name + " (" + str(floor(relative_mass*100)) + "%)"
		else:
			mass_scale.get_child(i).visible = false

	# temperature scale
	temperature_scale.get_node("EmptySpace").size_flags_stretch_ratio = (star.max_temperature-star.temperature)/star.max_temperature
	temperature_scale.get_node("CurrentTemperature").size_flags_stretch_ratio = star.temperature/star.max_temperature
	temperature_scale.get_node("CurrentTemperature/Label").text = str(floor(star.temperature)) + " MK"
	temperature_scale.get_node("CurrentTemperature").self_modulate = Color.from_hsv(clamp(star.temperature/star.max_temperature, 0.0, 1.0), 1.0, 1.0)

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

	# check temperature
	if star.temperature < 0.0:
		game_over_windows.visible = true
		reason_label.text = "Your star is burn out"
	if star.temperature > star.max_temperature:
		game_over_windows.visible = true
		reason_label.text = "Your star is explode"

func restart() -> void:
	get_tree().reload_current_scene()
