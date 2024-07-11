shader_type canvas_item;

uniform float line_thickness : hint_range(0, 10) = 2.5;
uniform bool on = false;

const vec2 OFFSETS[8] = {
	vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1), 
	vec2(1, -1), vec2(1, 0), vec2(1, 1)
};

void fragment() {
	if (on){
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	float outline = 0.0;
	
	for (int i = 0; i < OFFSETS.length(); i++) {
		outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;
	}
	outline = min(outline, 1.0);
	
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, vec4(1,0,0,1), outline - color.a);
	}
}