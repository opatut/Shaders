uniform sampler2D tex;
uniform float total_time;
float speed = 0.5;
float fac = 0.01;

// advanced settings
float amplitude = 0.01;	// factor of final displacement
float velocity = 10;	// screens per second
float wavelength = 0.1;		// screens

// calculated values
float peroid_time = wavelength / velocity;
float frequency = 1.0 / peroid_time;

float pi = 2.0 * asin(1.0);

float floatToRad(float f) {
	//f = clamp(f, 0.0, 1.0);
	return pi * 2 * f;
}

float timeForDistance(float distance) {
	return distance / velocity;
}
float phaseForDistance(float distance) { // 0..1
	return mod(distance, wavelength) / wavelength;
}

float displacementForPhase(float phase) { // -1 .. 1
	return sin(floatToRad(phase));
}

float displacementForDistance(float distance) {
	return displacementForPhase(phaseForDistance(distance));
}
float GetPhase(vec2 point1, vec2 point2, float time) {
	float distance = sqrt( pow(point1.x - point2.x,2) + pow(point1.y - point2.y, 2) );
	if(timeForDistance(distance) > time) {
		return 0.0;
	} else {
		return displacementForDistance(distance) * sin(time);
	}
}

/*vec2 transformCoord(vec2 orig) {

}*/

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
	return c * GetPhase(p, vec2(0,0), total_time);
}

void main() {
	//vec2 coord = transformCoord(gl_TexCoord[0].st);
	vec2 coord = gl_TexCoord[0].st;
	gl_FragColor = transformColor(texture2D(tex, coord), coord);
}
