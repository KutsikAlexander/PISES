class_name Reaction

extends Resource

@export var reaction_name: String
@export var description: String
@export var mass_threshold: float
@export var temperature_threshold: float
@export var input_chanel: Chanel
@export var output_chanel: Chanel
@export_range(0.0, 1.0) var mass_defect: float = 0.9
@export var energy_gain: float