class_name Star

extends Node

# general variables
var masses: Dictionary
var current_isotope: Isotope
var mass_per_click: float = 1.0
var temperature: float = 0.0
var max_temperature: float = 100.0

# coefficients
@export var mass_to_temperature: float = 1.0
@export var mass_to_max_temperature: float = 100
@export var temperature_loss: float = 0.1
@export var reactions_intensity: float = 0.1

#isotopes and reactions
@export var isotopes: Array[Isotope]
@export var reactions: Array[Reaction]

# child nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var particle: CPUParticles2D = $CPUParticles2D
@onready var light: PointLight2D = $PointLight2D

func _ready() -> void:
	for isotope in isotopes:
		masses[isotope.name] = 0.0
	masses[isotopes[0].name] = 5.0

	current_isotope = isotopes[0]

func _process(delta: float) -> void:
	if temperature > 0.0:
		temperature -= temperature_loss * delta
		particle.emitting = true
		light.enabled =true
	else:
		particle.emitting = false
		light.enabled =false

	for reaction:Reaction in reactions:
		if temperature > reaction.temperature_threshold or sum_masses() > reaction.mass_threshold:
			# find bottleneck
			var bottleneck_mass: float = INF
			for input_isotope in reaction.input_chanel.isotopes:
				if masses[input_isotope.name] >= 0.0 and masses[input_isotope.name] < bottleneck_mass:
					bottleneck_mass = masses[input_isotope.name]
			
			# for the safety
			if bottleneck_mass == INF:
				break
			
			# add mass to new isotope
			for output_isotope in reaction.output_chanel.isotopes:
				masses[output_isotope.name] += bottleneck_mass * reaction.mass_defect * reaction.input_chanel.probability * reaction.output_chanel.probability * reactions_intensity * delta
	
			# add temperature
			temperature += bottleneck_mass * reaction.energy_gain * reaction.input_chanel.probability * reaction.output_chanel.probability * mass_to_temperature * delta * reactions_intensity

			# subtract mass from input isotope
			for input_isotope in reaction.input_chanel.isotopes:
				masses[input_isotope.name] -= bottleneck_mass * reaction.input_chanel.probability * reactions_intensity * delta
	
	#set max mass
	max_temperature = sum_masses()*mass_to_max_temperature

	# update effects
	sprite.self_modulate = Color.from_hsv(clamp(temperature/max_temperature, 0.0, 1.0), 1.0, 1.0)
	particle.color = Color.from_hsv(clamp(temperature/max_temperature, 0.0, 1.0), 1.0, 1.0)
	if temperature > max_temperature:
		particle.explosiveness = 1.0
	light.energy = temperature/max_temperature

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		masses[current_isotope.name] += mass_per_click

func sum_masses() -> float:
	var sum: float = 0.0
	for isotope in isotopes:
		sum += masses[isotope.name]
	return sum

func change_isotope(index: int) -> void:
	current_isotope = isotopes[index]

func change_mass_per_click(value: float) -> void:
	mass_per_click = value
