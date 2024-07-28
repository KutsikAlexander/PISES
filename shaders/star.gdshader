shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform float speed = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = COLOR*texture(noise, UV + vec2(1.0, 0.0) * speed * TIME);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
