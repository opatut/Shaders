uniform sampler2D tex;
uniform float total_time;
float pi = 2.0 * asin(1.0);

float rand(float c){
    return sin(c);
}

vec2 rand(vec2 co){
    return vec2(sin(co.x), cos(co.y));
}

vec2 transformCoord(vec2 orig) {
    //orig *= total_time;
    vec2 r = 10.0 * total_time* vec2(orig.x - 0.5, orig.y - 0.5);
    float f = 0.04;
    return orig + vec2(f*rand(r).x, f*rand(r).y);
}

void main() {
    vec2 coord = transformCoord(gl_TexCoord[0].st);
    gl_FragColor = texture2D(tex, coord);
}
