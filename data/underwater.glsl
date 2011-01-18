uniform sampler2D tex;
uniform float total_time;

float rand(float c){
    return sin(c);
    return fract(sin(dot(c ,12.9898)) * 43758.5453);
}

vec2 rand(vec2 co){
    return(vec2(sin(co.x), cos(co.y)));
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 transformCoord(vec2 orig) {
    //orig *= total_time;
    vec2 r = 2 * total_time * orig;
    float f = 0.05;
    return orig + vec2( f * rand(r).x*orig.x,
    f * rand(r).x * orig.x);
}

void main() {
    vec2 coord = transformCoord(gl_TexCoord[0].st);
    gl_FragColor = texture2D(tex, coord);
}
