uniform sampler2D tex;
uniform float total_time;
float speed = 0.5;
float fac = 0.01;
float point_size = 3.0;
vec2 points[3];

// advanced settings
float amplitude = 0.01;	// factor of final displacement
float velocity = 0.1;	// screens per second
float wavelength = 0.1;		// screens

// calculated values
float period_time = wavelength / velocity;
float frequency = 1.0 / period_time;

float pi = 2.0 * asin(1.0);

float GetPhase(vec2 point1, vec2 point2, float time) {
	float distance = sqrt( pow(point1.x - point2.x,2) + pow(point1.y - point2.y, 2) );
	if (distance / velocity >= time) {
		return 0.0;
	} else {
		return sin((time / period_time - distance / wavelength) * 2 * pi);
	}
}

/*float rand(float c){
    return sin(c);
}

vec2 rand(vec2 co){
    return vec2(sin(co.x), cos(co.y));
}

vec2 transformCoord(vec2 orig) {
    // has to repeat over time [0..1]
	float r = sin(speed * total_time);

	vec2 co = orig - vec2(0.5, 0.5);

	vec2 new_orig = vec2(r * sin( cos(co.x * 10 - 1.0) + total_time),
						 r * sin( cos(co.y * 10 + 1.0) + total_time));
	return orig + fac * new_orig;
}*/

vec4 transformColor(vec4 c, vec2 p) {
	float fac = 0;
	for(int i = 0; i < point_size; ++i) {
		fac += GetPhase(p, points[i], total_time) / point_size;
	}
	return c * fac;
}

void main() {

	points[0] = vec2(0.2,0.2);
	points[1] = vec2(0.8,0.3);
	points[2] = vec2(0.1,0.6);
	//vec2 coord = transformCoord(gl_TexCoord[0].st);
	vec2 coord = gl_TexCoord[0].st;
	gl_FragColor = transformColor(texture2D(tex, coord), coord);
}
