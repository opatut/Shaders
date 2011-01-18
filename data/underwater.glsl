uniform sampler2D tex;
uniform float time;

vec2 transformCoord(vec2 orig) {
    orig *= 5;
    orig = mod(orig, 1.0);
    return orig;
}

void main() {
    vec2 coord = transformCoord(gl_TexCoord[0].st);
    gl_FragColor = texture2D(tex, coord);
}
