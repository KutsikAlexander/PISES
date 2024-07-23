extends Node

# general variables
var masses: Array[float]
var current_isotope: Reaction.ISOTOPE = Reaction.ISOTOPE.H
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

# UI
@export var mass_label: Label
@export var temperature_label: Label
@export var isotope_menu: OptionButton
@export var mass_per_click_spin_box: SpinBox
@export var mass_scale: Container
@export var temperature_scale: Container
@export var reactions_temperature_scale: Container

func _ready() -> void:
	for isotope in Reaction.ISOTOPE.values():
		masses.insert(isotope, 0.0)
		isotope_menu.add_item(Reaction.ISOTOPE.keys()[isotope])
		isotope_menu.set_item_disabled(isotope, true)

	masses[0] = 10.0
	isotope_menu.set_item_disabled(0, false)
	isotope_menu.select(0)

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
			isotope_menu.set_item_disabled(reaction.product_isotope,false) # activate new isotope
			masses[reaction.product_isotope] += masses[reaction.consume_isotope] * (1.0-reaction.mass_defect) * delta * reactions_intensity * (temperature - reaction.temperature_threshold)
			temperature += masses[reaction.consume_isotope] * reaction.mass_defect * mass_to_temperature * delta * reactions_intensity
			masses[reaction.consume_isotope] -= masses[reaction.consume_isotope] * delta * reactions_intensity * (temperature - reaction.temperature_threshold)
		elif sum_masses() > reaction.mass_threshold:
			isotope_menu.set_item_disabled(reaction.product_isotope,false) # activate new isotope
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

	# update UI
	var mass_text: String = ""
	for isotope in Reaction.ISOTOPE.values():
		if masses[isotope] > 0.0:
			mass_text += Reaction.ISOTOPE.keys()[isotope] + ":" + str(floor(masses[isotope])) + " Gg (" + str(floor(masses[isotope]/sum_masses()*100)) + "%) \n"
	mass_label.text = mass_text
	temperature_label.text = str(floor(temperature)) + " kK / " + str(floor(max_temperature)) + " kK"
	
	# mass scale
	for i in range(0, Reaction.ISOTOPE.size()):
		var relative_mass: float = masses[i]/sum_masses()
		if relative_mass > 0.01:
			mass_scale.get_child(i).visible = true
			mass_scale.get_child(i).size_flags_stretch_ratio = relative_mass
			mass_scale.get_child(i).tooltip_text = Reaction.ISOTOPE.keys()[i] + " " + str(floor(masses[i])) + " Gg"
			mass_scale.get_child(i).get_node("Label").text = Reaction.ISOTOPE.keys()[i] + " (" + str(floor(relative_mass*100)) + "%)"
		else:
			mass_scale.get_child(i).visible = false

	# temperature scale
	temperature_scale.get_node("EmptySpace").size_flags_stretch_ratio = (max_temperature-temperature)/max_temperature
	temperature_scale.get_node("CurrentTemperature").size_flags_stretch_ratio = temperature/max_temperature
	temperature_scale.get_node("CurrentTemperature/Label").text = str(floor(temperature)) + " kK"
	temperature_scale.get_node("CurrentTemperature").self_modulate = Color.from_hsv(temperature/max_temperature, 1.0, 1.0)

	#reactions temperature scale
	for i in range(0, reactions.size()):
		reactions_temperature_scale.get_node("HSeparator" + str(i+1) + "/Label").text = str(floor(reactions[i].temperature_threshold))
		var relative_temperature: float = reactions[i].temperature_threshold/max_temperature
		if relative_temperature > 1.0:
			reactions_temperature_scale.get_node("EmptySpace" + str(i+1)).visible = false
			reactions_temperature_scale.get_node("HSeparator" + str(i+1)).visible = false
		else:
			reactions_temperature_scale.get_node("EmptySpace7").size_flags_stretch_ratio = (max_temperature-reactions[i].temperature_threshold)/max_temperature
			reactions_temperature_scale.get_node("EmptySpace" + str(i+1)).visible = true
			reactions_temperature_scale.get_node("HSeparator" + str(i+1)).visible = true
		if i == 0:
			reactions_temperature_scale.get_node("EmptySpace" + str(i+1)).size_flags_stretch_ratio = reactions[0].temperature_threshold/max_temperature	
		else: 
			reactions_temperature_scale.get_node("EmptySpace" + str(i+1)).size_flags_stretch_ratio = (reactions[i].temperature_threshold-reactions[i-1].temperature_threshold)/max_temperature

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		masses[current_isotope] += mass_per_click_spin_box.value

func sum_masses() -> float:
	var sum: float = 0.0
	for mass in masses:
		sum += mass
	return sum

func change_isotope(index: int) -> void:
	current_isotope = index
