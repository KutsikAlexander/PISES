class_name MassScale

extends Control

var isotopes: Array[Isotope]
var masses: Dictionary
@onready var mass_label: Label = $VBoxContainer/MassLabel
@onready var mass_scale: Container = $VBoxContainer/VBoxContainer
var isotope_on_mass_scale_template: PackedScene = load("res://scenes/UI/isotope_on_mass_scale.tscn")

func set_isotopes_and_masses(star_isotopes: Array[Isotope], star_masses: Dictionary) -> void:
	isotopes = star_isotopes
	masses = star_masses

	for isotope in isotopes:
		var child: IsotopeOnMassScale = isotope_on_mass_scale_template.instantiate()
		mass_scale.add_child(child)
		child.set_isotope(isotope)

func _process(delta: float) -> void:
	# update mass label
	mass_label.text = "Mass: " + str(floor(sum_masses())) + " Gg"

	# update mass tooltip and isotope labels
	var mass_text: String = ""
	for child in mass_scale.get_children():
		if child is IsotopeOnMassScale:
			child.relative_scale = masses[child.isotope.name]/sum_masses()
			if masses[child.isotope.name] > 0.1:
				mass_text += child.isotope.name + ":" + str(floor(masses[child.isotope.name])) + " Gg (" + str(floor(masses[child.isotope.name]/sum_masses()*100)) + "%) \n"
	mass_scale.tooltip_text = mass_text

func sum_masses() -> float:
	var sum: float = 0.0
	for isotope:Isotope in isotopes:
		sum += masses[isotope.name]
	return sum
