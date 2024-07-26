class_name Star

extends Node

# general variables
var masses: Array[float]
var current_isotope: Reaction.ISOTOPE = Reaction.ISOTOPE.H
var mass_per_click: float = 1.0
var temperature: float = 0.0
var max_temperature: float = 100.0
var ignite: bool = false

# coefficients
@export var mass_to_temperature: float = 1.0
@export var mass_to_max_temperature: float = 100
@export var temperature_loss: float = 0.1
@export var reactions_intensity: float = 0.1

#reactions
@export var reactions: Array[Reaction]

# child nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var particle: CPUParticles2D = $CPUParticles2D
@onready var light: PointLight2D = $PointLight2D

func _ready() -> void:
	for isotope in Reaction.ISOTOPE.values():
		masses.insert(isotope, 0.0)
	masses[0] = 10.0

func _process(delta: float) -> void:
	if temperature > 0.0:
		ignite = true
		temperature -= temperature_loss * delta
		particle.emitting = true
		light.enabled =true
	if temperature <= 0.0 and ignite:
		particle.emitting = false
		light.enabled =false
	for reaction:Reaction in reactions:
		if temperature > reaction.temperature_threshold:
			masses[reaction.product_isotope] += masses[reaction.consume_isotope] * (1.0-reaction.mass_defect) * delta * reactions_intensity * (temperature - reaction.temperature_threshold)
			temperature += masses[reaction.consume_isotope] * reaction.mass_defect * mass_to_temperature * delta * reactions_intensity
			masses[reaction.consume_isotope] -= masses[reaction.consume_isotope] * delta * reactions_intensity * (temperature - reaction.temperature_threshold)
		elif sum_masses() > reaction.mass_threshold:
			masses[reaction.product_isotope] += masses[reaction.consume_isotope] * (1.0-reaction.mass_defect) * delta * reactions_intensity
			temperature += masses[reaction.consume_isotope] * reaction.mass_defect * mass_to_temperature * delta * reactions_intensity
			masses[reaction.consume_isotope] -= masses[reaction.consume_isotope] * delta * reactions_intensity

	#set max mass
	max_temperature = sum_masses()*mass_to_max_temperature

	# update effects
	sprite.self_modulate = Color.from_hsv(temperature/max_temperature, 1.0, 1.0)
	particle.color = Color.from_hsv(temperature/max_temperature, 1.0, 1.0)
	if temperature > max_temperature:
		particle.explosiveness = 1.0
	light.energy = temperature/max_temperature*16
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		masses[current_isotope] += mass_per_click

func sum_masses() -> float:
	var sum: float = 0.0
	for mass in masses:
		sum += mass
	return sum

func change_isotope(index: int) -> void:
	current_isotope = index

func change_mass_per_click(value: float) -> void:
	mass_per_click = value