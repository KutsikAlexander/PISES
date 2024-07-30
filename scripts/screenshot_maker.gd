extends Node

@export var canvas: CanvasLayer
@export var timer: Timer
var n:int = 0

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_accept"):
		timer.start()
		canvas.visible = false

func _process(delta: float) -> void:
	if not timer.is_stopped():
		var vpt: Viewport = get_viewport()
		var tex: Texture = vpt.get_texture()
		var img: Image = tex.get_image()
		img.save_png("itch.io/for_gif/img" + str(n) + ".png")
		n += 1

func _on_timer_timeout() -> void:
	canvas.visible = true
