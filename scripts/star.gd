extends Node

# general variables
var masses: Array[float]
@export var current_isotope: Reaction.ISOTOPE
var temperature: float = 0.0
var max_temperature: float = 100.0
@export var mass_per_click: float = 1.0

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

# UI
@export var mass_label: Label
@export var temperature_label: Label
@export var isotope_menu: OptionButton

func _ready() -> void:
	for isotope in Reaction.ISOTOPE.values():
		masses.insert(isotope, 0.0)
		isotope_menu.add_item(Reaction.ISOTOPE.keys()[isotope])
		isotope_menu.set_item_disabled(isotope, true)

	isotope_menu.set_item_disabled(0, false)
	isotope_menu.select(0)

func _process(delta: float) -> void:
	if temperature > 0.0:
		temperature -= temperature_loss * delta
	for reaction:Reaction in reactions:
		if temperature > reaction.temperature_threshold or sum_masses() > reaction.mass_threshold:
			isotope_menu.set_item_disabled(reaction.product_isotope,false) # activate new isotope
			# print("produce:")
			# print(masses[reaction.consume_isotope] * (1.0-reaction.mass_defect) * delta * reactions_intensity)
			masses[reaction.product_isotope] += masses[reaction.consume_isotope] * (1.0-reaction.mass_defect) * delta * reactions_intensity * temperature
			temperature += masses[reaction.consume_isotope] * reaction.mass_defect * mass_to_temperature * delta * reactions_intensity
			# print("consume:")
			# print(masses[reaction.consume_isotope] * delta * reactions_intensity)
			masses[reaction.consume_isotope] -= masses[reaction.consume_isotope] * delta * reactions_intensity * temperature

	#set max mass
	max_temperature = sum_masses()*mass_to_max_temperature

	# update effects
	sprite.self_modulate = Color.from_hsv(temperature/max_temperature, 1.0, 1.0)
	if floori(temperature) > 0 and floori(temperature) != particle.amount:
		particle.amount = floori(temperature)
		particle.color = Color.from_hsv(temperature/max_temperature, 1.0, 1.0)
		if temperature > max_temperature:
			particle.explosiveness = 1.0
		else:
			particle.explosiveness = 0.0

	# update UI
	var mass_text: String = ""
	for isotope in Reaction.ISOTOPE.values():
		if masses[isotope] > 0.0:
			mass_text += Reaction.ISOTOPE.keys()[isotope] + ":" + str(floor(masses[isotope])) + " Gg (" + str(floor(masses[isotope]/sum_masses()*100)) + "%) \n"
	mass_label.text = mass_text
	temperature_label.text = str(floor(temperature)) + " kK / " + str(floor(max_temperature)) + " kK"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		masses[current_isotope] += mass_per_click*(current_isotope+1)

func sum_masses() -> float:
	var sum: float = 0.0
	for mass in masses:
		sum += mass
	return sum

func change_isotope(index: int) -> void:
	current_isotope = index
