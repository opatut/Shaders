uniform sampler2D tex;
uniform float total_time;
float speed = 1.0;
float fac = 0.02;
float pi = 2.0 * asin(1.0);

float rand(float c){
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
}

void main() {
    vec2 coord = transformCoord(gl_TexCoord[0].st);
    gl_FragColor = texture2D(tex, coord);
}
