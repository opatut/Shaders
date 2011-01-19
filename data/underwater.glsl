uniform sampler2D tex;
uniform float total_time;

float PI = 2.0 * asin(1.0);

struct WaveEmitter {
	vec2 mPosition; // = vec2(0.5, 0.5);
	float mAmplitude; // = 0.01;	// factor of final displacement
	float mVelocity; // = 0.05;		// screens per second
	float mWavelength; // = 0.3;	// screens

	float GetPeriodTime() {
		return mWavelength / mVelocity;
	}
};

float emitter_size = 3.0;
WaveEmitter emitter[3];


float GetPhase(vec2 point, WaveEmitter emit, float time) {
	float distance = sqrt( pow(point.x - emit.mPosition.x,2) + pow(point.y - emit.mPosition.y, 2) );
	if (distance / emit.mVelocity >= time) {
		return 0.0;
	} else {
		return sin((time / emit.GetPeriodTime() - distance / emit.mWavelength) * 2 * PI);
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
	for(int i = 0; i < emitter_size; ++i) {
		fac += GetPhase(p, emitter[i], total_time + 100) / emitter_size;
	}
	return c * (fac+1.0)/2;
}

void main() {
	WaveEmitter emit0;
	emit0.mPosition = vec2(0.7,1.4);
	emit0.mAmplitude = 0.01;
	emit0.mVelocity = 0.1;
	emit0.mWavelength = 0.3;
	emitter[0] = emit0;

	WaveEmitter emit1;
	emit1.mPosition = vec2(0.8,-0.3);
	emit1.mAmplitude = 0.01;
	emit1.mVelocity = 0.15;
	emit1.mWavelength = 0.3;
	emitter[1] = emit1;

	WaveEmitter emit2;
	emit2.mPosition = vec2(-0.1,0.6);
	emit2.mAmplitude = 0.01;
	emit2.mVelocity = 0.05;
	emit2.mWavelength = 0.1;
	emitter[2] = emit2;

	//vec2 coord = transformCoord(gl_TexCoord[0].st);
	vec2 coord = gl_TexCoord[0].st;
	gl_FragColor = transformColor(texture2D(tex, coord), coord);
}
