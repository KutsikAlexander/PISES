class_name IsotopeMenu extends Control

@onready var isotope_menu: OptionButton = $GridContainer/OptionButton

var isotopes: Array[Isotope]
var reactions: Array[Reaction]

func set_isotopes(_isotopes: Array[Isotope]) -> void:
	isotopes = _isotopes

	# construct isotope menu
	for i: int in range(0, isotopes.size()):
		isotope_menu.add_item(isotopes[i].name)
		isotope_menu.set_item_disabled(i, true)
	isotope_menu.set_item_disabled(0, false)
	isotope_menu.select(0)

func activate_isotope(isotope: Isotope) -> void:
	for i in range(0, isotope_menu.item_count):
		if isotope_menu.get_item_text(i) == isotope.name:
			isotope_menu.set_item_disabled(i,false)
			break
