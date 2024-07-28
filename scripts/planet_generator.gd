extends Node2D

@export var number_of_planets: int = 1
@export var orbit_radius_gap: float = 1.0
@export var orbit_radius_fluctuation: float = 0.1
@export var min_speed: float = 1.0
@export var max_speed: float = 2.0
@export var min_scale: float = 0.1
@export var max_scale: float = 1.0

@onready var planet_template: PackedScene = load("res://scenes/planet.tscn")

func _ready() -> void:
    for n in range(0, number_of_planets):
        var planet: Planet = planet_template.instantiate()
        add_child(planet)
        planet.speed_around_star = randf_range(min_speed, max_speed)/(n+1)
        planet.rotate(randf_range(0.0, 2*PI))
        planet.set_orbit_radius((n+1)*orbit_radius_gap + randf_range(-orbit_radius_fluctuation, orbit_radius_fluctuation))
        planet.sprite.scale = Vector2(1,1)*randf_range(min_scale, max_scale)
