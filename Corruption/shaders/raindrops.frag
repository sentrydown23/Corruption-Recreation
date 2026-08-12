#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D
#define S(a, b, t) smoothstep(a, b, t)

uniform float uRainControl;
uniform float uScale;
uniform float uRainTime;
uniform float uLightning;

vec3 N13(float p) {
    vec3 p3 = fract(vec3(p) * vec3(.1031, .11369, .13787));
    p3 += dot(p3, p3.yzx + 19.19);
    return fract(vec3((p3.x + p3.y) * p3.z, (p3.x + p3.z) * p3.y, (p3.y + p3.z) * p3.x));
}

vec4 N14(float t) {
    return fract(sin(t * vec4(123., 1024., 1456., 264.)) * vec4(6547., 345., 8799., 1564.));
}

float N(float t) {
    return fract(sin(t * 12345.564) * 7658.76);
}

float Saw(float b, float t) {
    return S(0., b, t) * S(1., b, t);
}

vec2 DropLayer2(vec2 uv, float t) {
    vec2 UV = uv;

    uv.y -= t * 0.35;
    vec2 a = vec2(6., 1.);
    vec2 grid = a * 2.;
    vec2 id = floor(uv * grid);

    float colShift = N(id.x);
    uv.y += colShift;

    id = floor(uv * grid);
    vec3 n = N13(id.x * 35.2 + id.y * 2376.1);
    vec2 st = fract(uv * grid) - vec2(.5, 0);

    float x = n.x - .5;

    float y = UV.y * 20.;
    float wiggle = sin(y + sin(y));
    x += wiggle * (.5 - abs(x)) * (n.z - .5);
    x *= .7;

    float ti = fract(t + n.z);
    float dropProg = S(0.0, 0.85, ti);
    y = dropProg * 0.8 + 0.1;

    vec2 p = vec2(x, y);

    float d = length((st - p) * a.yx);

    float mainDrop = S(.4, .0, d);

    float r = sqrt(S(0., y, st.y));
    float cd = abs(st.x - x);
    float trail = S(.23 * r, .15 * r * r, cd);
    float trailFront = S(-.02, .02, y - st.y);
    trail *= trailFront * r * r;

    y = UV.y;
    float trail2 = S(.2 * r, .0, cd);
    float droplets = max(0., (sin(y * (1. - y) * 120.) - st.y)) * trail2 * trailFront * n.z;
    y = fract(y * 10.) + (st.y - .5);
    float dd = length(st - vec2(x, y));
    droplets = S(.3, 0., dd);

    float dropMask = S(.4, .7, n.y);
    float lifeFade = S(1.0, 0.85, ti);
    mainDrop *= dropMask * lifeFade;
    droplets *= dropMask * lifeFade;

    float m = mainDrop + droplets * r * trailFront;

    return vec2(m, trail);
}

float StaticDrops(vec2 uv, float t) {
    uv *= 28.;

    vec2 id = floor(uv);
    uv = fract(uv) - .5;
    vec3 n = N13(id.x * 107.45 + id.y * 3543.654);
    vec2 p = (n.xy - .5) * .7;
    float d = length(uv - p);

    float fade = Saw(.025, fract(t * 0.35 + n.z));
    float presence = S(.65, .85, fract(n.z * 10.));
    float c = S(.3, 0., d) * presence * fade;
    return c;
}

vec2 Drops(vec2 uv, float t, float l0, float l1, float l2) {
    float s = StaticDrops(uv, t) * l0;
    vec2 m1 = DropLayer2(uv, t) * l1;
    vec2 m2 = DropLayer2(uv * 1.85, t) * l2;

    float c = s + m1.x + m2.x;
    c = S(.2, .8, c);

    return vec2(c, max(m1.y * l0, m2.y * l1));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord.xy - .5 * iResolution.xy) / iResolution.y;
    vec2 UV = fragCoord.xy / iResolution.xy;

    float T = uRainTime * 0.005;
    float t = T * .2;

    float rainAmount = clamp(uRainControl, 0.0, 1.0);

    float staticDrops = S(-.5, 1., rainAmount) * 0.4;
    float layer1 = S(.25, .75, rainAmount) * 0.75;
    float layer2 = S(.0, .5, rainAmount) * 0.5;

    vec2 scaledUv = uv * max(0.01, uScale);
    vec2 c = Drops(scaledUv, t, staticDrops, layer1, layer2);

    vec2 e = vec2(.001, 0.0);
    float cx = Drops(scaledUv + e, t, staticDrops, layer1, layer2).x;
    float cy = Drops(scaledUv + e.yx, t, staticDrops, layer1, layer2).x;
    vec2 n = vec2(cx - c.x, cy - c.x);

    vec3 col = flixel_texture2D(iChannel0, UV + n * rainAmount).rgb;
    col *= 1. + uLightning;
    col *= vec3(0.97, 0.985, 1.02);

    fragColor = vec4(col, flixel_texture2D(iChannel0, UV).a);
}

void main() {
    mainImage(gl_FragColor, openfl_TextureCoordv * openfl_TextureSize);
}