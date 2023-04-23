shader_type particles;

uniform sampler2D emission_texture;

uniform float transition_duration;
uniform float transition : hint_range(0.0, 1.0);

const uint numX = 64u;
const uint numY = 64u;
const float dstX = 2.0;
const float dstY = 2.0;
const float sizeX = 2.0;
const float sizeY = 2.0;

void start() {
	TRANSFORM[0] = vec4(sizeX,0,0,0);
	TRANSFORM[1] = vec4(0,sizeY,0,0);

	uint ix = INDEX % numX;
	uint iy = (INDEX - ix) / numX;
	
	vec2 numV = vec2(float(numX), float(numY));
	vec2 pos_i = vec2(float(ix), float(iy));
	vec2 pos_uv = pos_i / numV;
	vec2 pos = (pos_i - 0.5 * numV) * vec2(dstX, dstY);
	
	COLOR = texture(emission_texture, pos_uv);

	ACTIVE = COLOR.a > 0.1;

	TRANSFORM[3].xy = pos;

	CUSTOM.xy = pos;
	CUSTOM.w = 0.0;
}

void process() {
	CUSTOM.w += DELTA;
	
	float a0 = atan(CUSTOM.x, CUSTOM.y);
	float l0 = length(CUSTOM.xy);
	
	float l1_unit = pow(1.0 - abs(sin(float(INDEX))), 1.5);
	float l1 = l1_unit * (30.0 + 10.0 * cos(10.0 * TIME * sin(float(INDEX) * 1.232)));
	float spin_speed = (5.0 + cos(float(INDEX) * 1.2312) * 2.0) / l1_unit;
	float a1 = a0 + TIME * spin_speed;
	
	vec2 pos_spin = vec2(sin(a1), cos(a1)) * l1;

	float transition_k = transition;//CUSTOM.w / transition_duration;

	float a02 = a0 + spin_speed * transition_k * 0.1;
	vec2 pos_sprite = vec2(sin(a02), cos(a02)) * l0 * (1.0 + transition_k * 2.0);
	
	
	TRANSFORM[3].xy = mix(pos_sprite, pos_spin, min(1.0, transition_k));
}










