class_name IsotopeOnMassScale

extends Control

var isotope: Isotope
var relative_scale: float = 1.0
@onready var label: Label = $Label

func _ready() -> void:
	size_flags_vertical = Control.SIZE_EXPAND_FILL

func set_isotope(new_isotope:Isotope) -> void:
	isotope = new_isotope
	# color = isotope.color

func _process(delta: float) -> void:
	if relative_scale > 0.01:
		visible = true
		size_flags_stretch_ratio = relative_scale
		label.text = isotope.name + " (" + str(floor(relative_scale*100)) + "%)"
	else:
		visible = false