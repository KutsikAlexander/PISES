extends Node

@export var star: Star

#scales
@export var mass_scale: MassScale
@export var temperature_scale: TemperatureScale
@export var reaction_temperature_scale: ReactionTemperatureScale

@export var isotope_menu: OptionButton
@export var mass_per_click_spin_box: SpinBox

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
	mass_scale.set_isotopes_and_masses(star.isotopes, star.masses)

	# construct reaction temperature scale
	reaction_temperature_scale.set_reactions(star.reactions)

func _process(delta: float) -> void:
	# activate new isotope
	for reaction:Reaction in star.reactions:
		if star.temperature > reaction.temperature_threshold or star.sum_masses() > reaction.mass_threshold:
			for isotope in reaction.output_chanel.isotopes:
				for i in range(0, star.isotopes.size()):
					if star.isotopes[i] == isotope:
						isotope_menu.set_item_disabled(i,false)
						break

	# temperature scale
	temperature_scale.set_temperature(star.temperature, star.max_temperature)

	#reactions temperature scale
	reaction_temperature_scale.set_max_temperature(star.max_temperature)

	# check temperature
	if star.temperature < 0.0:
		game_over_windows.visible = true
		reason_label.text = "Your star is burn out"
		star.set_process(false)
		star.set_process_unhandled_input(false)
	elif star.temperature > star.max_temperature:
		game_over_windows.visible = true
		reason_label.text = "Your star is explode"
		star.set_process(false)
		star.set_process_unhandled_input(false)

func restart() -> void:
	get_tree().reload_current_scene()
