class_name Planet

extends Node2D

@export var speed_around_star: float = 1.0
@export var speed_around_axis: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D
@export var images: Array[Texture2D]

func _ready() -> void:
	sprite.texture = images.pick_random()

func _process(delta: float) -> void:
	rotate(delta*speed_around_star)
	#sprite.rotate(delta*speed_around_axis)

func set_orbit_radius(radius: float) -> void:
	sprite.position.x = -radius