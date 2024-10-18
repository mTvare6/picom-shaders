// The Gruvbox colorscheme is used by default, 
// but you can make your own by changing `colors`

#version 330
uniform float opacity;
uniform float time;
uniform bool invert_color;
uniform sampler2D tex;
in vec2 texcoord;

vec4 default_post_processing(vec4 c);


float sin_rand() {
  return sin(gl_FragCoord.x + cos(gl_FragCoord.y));
}

float random(float seedChange) {
  vec2 seed = gl_FragCoord.xy + sin(seedChange);
  return fract(dot(vec2(sin(mod(seed.x / cos(seed.y), 5.0) * 10000.0)), vec2(1.1, 12.2)));
}

vec4 window_shader() {
	vec2 texsize = textureSize(tex, 0);
	vec4 c = texture2D(tex, texcoord / texsize, 0);
  vec4 d = c;
  vec3 colors[16];

  colors[0] = vec3(0.1568627450980392, 0.1568627450980392, 0.1568627450980392);
  colors[1] = vec3(0.8, 0.1411764705882353, 0.11372549019607843);
  colors[2] = vec3(0.596078431372549, 0.592156862745098, 0.10196078431372549);
  colors[3] = vec3(0.8431372549019608, 0.6, 0.12941176470588237);
  colors[4] = vec3(0.27058823529411763, 0.5215686274509804, 0.5333333333333333);
  colors[5] = vec3(0.6941176470588235, 0.3843137254901961, 0.5254901960784314);
  colors[6] = vec3(0.40784313725490196, 0.615686274509804, 0.41568627450980394);
  colors[7] = vec3(0.8352941176470589, 0.7686274509803922, 0.6313725490196078);
  colors[8] = vec3(0.5725490196078431, 0.5137254901960784, 0.4549019607843137);
  colors[9] = vec3(0.8, 0.1411764705882353, 0.11372549019607843);
  colors[10] = vec3(0.596078431372549, 0.592156862745098, 0.10196078431372549);
  colors[11] = vec3(0.8431372549019608, 0.6, 0.12941176470588237);
  colors[12] = vec3(0.27058823529411763, 0.5215686274509804, 0.5333333333333333);
  colors[13] = vec3(0.6941176470588235, 0.3843137254901961, 0.5254901960784314);
  colors[14] = vec3(0.4588235294117647, 0.7098039215686275, 0.6666666666666666);
  colors[15] = vec3(0.9215686274509803, 0.8588235294117647, 0.6980392156862745);
 
  float mindist = 100.0;
  int minind = 0;
  float mindist2 = 100.0;
  int minind2 = 0;
  for (int i = 0; i < 16; i++) {
    float dist = length(c.xyz - colors[i]);
    if (dist < mindist) {
      mindist2 = mindist;
      mindist = dist;
      minind2 = minind;
      minind = i;
    }
  }
  float ratio = mindist / (mindist + mindist2);
  float r = random(1.0) * 0.4 + 0.25;
  if (r > ratio)
    c.xyz = colors[minind];
  else 
    c.xyz = colors[minind2];

  c.xyz = mix(mix(colors[minind], colors[minind2], ratio), c.xyz, 0.5);
  
  if (invert_color)
    c = vec4(vec3(c.a, c.a, c.a) - vec3(c), c.a);
  c *= opacity;
  return default_post_processing(c);
}
