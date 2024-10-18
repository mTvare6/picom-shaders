#version 330
// Changes the behavior of inverting color to preserve the hue
// In other words, the invert flag will now only invert the 
// lightness value. This helps preserve the look of pictures and
// things while keeping the high contrast look.

uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;
in vec2 texcoord;

#define pi 3.14159265358979323846264
vec4 default_post_processing(vec4 c);

// adapted from https://stackoverflow.com/questions/9234724/how-to-change-hue-of-a-texture-with-glsl
vec3 hue_rotate(in vec3 c, in float hueAdjust) {
  const vec4  kRGBToYPrime = vec4 (0.299, 0.587, 0.114, 0.0);
  const vec4  kRGBToI     = vec4 (0.596, -0.275, -0.321, 0.0);
  const vec4  kRGBToQ     = vec4 (0.212, -0.523, 0.311, 0.0);

  const vec4  kYIQToR   = vec4 (1.0, 0.956, 0.621, 0.0);
  const vec4  kYIQToG   = vec4 (1.0, -0.272, -0.647, 0.0);
  const vec4  kYIQToB   = vec4 (1.0, -1.107, 1.704, 0.0);

  vec4    color   = vec4(c, 1.0);

  // Convert to YIQ
  float   YPrime  = dot (color, kRGBToYPrime);
  float   I      = dot (color, kRGBToI);
  float   Q      = dot (color, kRGBToQ);

  // Calculate the hue and chroma
  float   hue     = atan (Q, I);
  float   chroma  = sqrt (I * I + Q * Q);

  // Make the adjustments
  hue += hueAdjust * 2. * pi;

  // Convert back to YIQ
  Q = chroma * sin (hue);
  I = chroma * cos (hue);

  // Convert back to RGB
  vec4    yIQ   = vec4 (YPrime, I, Q, 0.0);
  color.r = dot (yIQ, kYIQToR);
  color.g = dot (yIQ, kYIQToG);
  color.b = dot (yIQ, kYIQToB);

  return color.rgb;
}

vec4 window_shader() {
  vec2 texsize = textureSize(tex, 0);
  vec4 c = texture2D(tex, texcoord / texsize, 0);
	
	if (invert_color) {
		c.xyz = 1.0 - c.xyz;
		c.xyz = hue_rotate(c.xyz, 0.5);
	}
	c *= opacity;
  return default_post_processing(c);
}
