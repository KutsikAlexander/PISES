class_name TemperatureScale

extends Control

var temperature: float
var max_temperature: float

@onready var max_temperature_label: Label = $VBoxContainer/MaxTemperatureLabel
@onready var current_temperature_label: Label = $VBoxContainer/Scale/StarTemperature/CurrentTemperature/Label
@onready var current_temperature_space: Control = $VBoxContainer/Scale/StarTemperature/CurrentTemperature
@onready var empty_space: Control = $VBoxContainer/Scale/StarTemperature/EmptySpace

func _process(delta: float) -> void:
	# update labels
	max_temperature_label.text = "Max: " + str(floor(max_temperature)) + " MK"

	# temperature scale
	empty_space.size_flags_stretch_ratio = (max_temperature-temperature)/max_temperature
	current_temperature_space.size_flags_stretch_ratio = temperature/max_temperature
	current_temperature_space.self_modulate = Color.from_hsv(clamp(temperature/max_temperature, 0.0, 1.0), 1.0, 1.0)
	current_temperature_label.text = str(floor(temperature)) + " MK"

func set_temperature(temp:float, max_temp:float) -> void:
	temperature = temp
	max_temperature = max_temp