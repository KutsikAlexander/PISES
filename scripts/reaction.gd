class_name Reaction

extends Resource

enum ISOTOPE {H, D, T, He, C, O, N, Fe}

@export var mass_threshold: float
@export var temperature_threshold: float
@export var consume_isotope: ISOTOPE
@export var product_isotope: ISOTOPE
@export_range(0.0, 1.0) var mass_defect: float
