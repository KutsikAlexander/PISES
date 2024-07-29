extends Node

@export var star: Star

#scales and menus
@export var mass_scale: MassScale
@export var temperature_scale: TemperatureScale
@export var reaction_temperature_scale: ReactionTemperatureScale
@export var isotope_menu: IsotopeMenu
@export var settings_menu: Control
@export var game_over_windows: Container
@export var reason_label: Label

func _ready() -> void:
	isotope_menu.set_isotopes(star.isotopes) # construct isotope menu
	mass_scale.set_isotopes_and_masses(star.isotopes, star.masses) # construct isotope mass scale
	reaction_temperature_scale.set_reactions(star.reactions) # construct reaction temperature scale

func _process(delta: float) -> void:
	temperature_scale.set_temperature(star.temperature, star.max_temperature)
	reaction_temperature_scale.set_max_temperature(star.max_temperature)

func game_over(reason: String = "No reason") -> void:
	game_over_windows.visible = true
	reason_label.text = reason

func restart() -> void:
	get_tree().reload_current_scene()

func open_settings() -> void:
		settings_menu.visible = !settings_menu.visible
