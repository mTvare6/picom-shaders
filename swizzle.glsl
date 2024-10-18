#version 330
#extension GL_ARB_shading_language_420pack: enable

#define CYCLE 5000 // The amount of miliseconds it takes to do a full "loop" around all the colors.

uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;
uniform float time;
in vec2 texcoord;

float get_decimal_part(float f) {
	return f - int(f);
}

float snap0(float f) {
	return (f < 0) ? 0 : f;
}

vec4 default_post_processing(vec4 c);

vec4 window_shader() {
  vec2 texsize = textureSize(tex, 0);
	vec4 c = texture2D(tex, texcoord / texsize, 0);
	float f = get_decimal_part(time / CYCLE);


	float p[3] = {
		snap0(0.33 - abs(f - 0.33)) * 4,
		snap0(0.33 - abs(f - 0.66)) * 4,
		snap0(0.33 - abs(f - 1.00)) * 4 + snap0(0.33 - abs(f - 0.0)) * 4
	};

	 c = vec4(
       p[0] * c.r + p[1] * c.g + p[2] * c.b,
       p[2] * c.r + p[0] * c.g + p[1] * c.b,
       p[1] * c.r + p[2] * c.g + p[0] * c.b,
       c.a * opacity
   );
   return default_post_processing(c);
}
