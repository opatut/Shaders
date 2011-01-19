uniform sampler2D tex;
uniform float total_time;
bool infinite = true;

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
	if (!infinite && distance / emit.mVelocity >= time) {
		return 0.0;
	} else {
		return sin((time / emit.GetPeriodTime() - distance / emit.mWavelength) * 2 * PI);
	}
}

vec2 transformCoord(vec2 orig) {
	vec2 final = orig;
	for(int i = 0; i < emitter_size; ++i) {
		vec2 rel = orig - emitter[i].mPosition;
		float fac = GetPhase(orig, emitter[i], total_time) * emitter[i].mAmplitude;
		final += fac * rel;
	}
	return final;
}

vec4 transformColor(vec4 c, vec2 p) {
	float fac = 0;
	float a = 0;
	for(int i = 0; i < emitter_size; ++i) {
		fac += GetPhase(p, emitter[i], total_time) * emitter[i].mAmplitude;
		a = emitter[i].mAmplitude;
	}
	fac = (fac / a + 1.0)/2.0;
	return c * fac;
}

void main() {
	WaveEmitter emit0;
	emit0.mPosition = vec2(0.1,0.7);
	emit0.mAmplitude = 0.005;
	emit0.mVelocity = 0.06;
	emit0.mWavelength = 0.7;
	emitter[0] = emit0;

	WaveEmitter emit1;
	emit1.mPosition = vec2(0.8,-0.1);
	emit1.mAmplitude = 0.005;
	emit1.mVelocity = 0.07;
	emit1.mWavelength = 0.6;
	emitter[1] = emit1;

	WaveEmitter emit2;
	emit2.mPosition = vec2(1.1,0.9);
	emit2.mAmplitude = 0.005;
	emit2.mVelocity = 0.05;
	emit2.mWavelength = 0.8;
	emitter[2] = emit2;

	vec2 coord = transformCoord(gl_TexCoord[0].st);
	//vec2 coord = gl_TexCoord[0].st;
	//gl_FragColor = transformColor(texture2D(tex, coord), coord);
	gl_FragColor = texture2D(tex, coord), coord;
}
