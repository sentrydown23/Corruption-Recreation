#pragma header

#define UNIFORM uniform

uniform float uRainControl; // Controls rain density
uniform float uScale;
uniform float uRainTime;    // CPU-accumulated integrated rain offset

float rand(vec2 a) {
    return fract(sin(dot(mod(a, vec2(1000.0)).xy, vec2(12.9898, 78.233))) * 43758.5453);
}

// Distance estimator for falling rain streaks
float rainDist(vec2 p, float scale, float control) {
    p *= 0.1;
    p.x += p.y * 0.1; // Wind sheer
    p.y -= uRainTime / scale; // Continuous integrated fall offset
    p.y *= 0.03; // Vertical stretch
    
    float ix = floor(p.x);
    p.y += mod(ix, 2.0) * 0.5 + (rand(vec2(ix)) - 0.5) * 0.3;
    
    float iy = floor(p.y);
    vec2 index = vec2(ix, iy);
    
    p -= index;
    p.x += (rand(index.yx) * 2.0 - 1.0) * 0.35;
    
    vec2 a = abs(p - 0.5);
    
    // Thicker rain streak dimensions
    float res = max(a.x * 0.4, a.y * 0.4) - 0.05;
    
    float density = clamp(control, 0.0, 1.0);
    bool empty = rand(index) < mix(1.0, 0.1, density);
    
    return empty ? 1.0 : res;
}

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec2 wpos = uv * 1000.0;
    
    float control = max(0.0, uRainControl);

    vec3 add = vec3(0.0);
    float rainSum = 0.0;

    const int numLayers = 4;
    float scales[4];
    scales[0] = 1.0;
    scales[1] = 1.8;
    scales[2] = 2.6;
    scales[3] = 4.8;

    vec2 uvOffset = vec2(0.0);

    for (int i = 0; i < numLayers; i++) {
        float scale = scales[i];
        float r = rainDist(wpos * scale / max(0.01, uScale) + 500.0 * float(i), scale, control);
        
        if (r < 0.0) {
            float v = (1.0 - exp(r * 5.0)) / scale * 2.0;
            uvOffset.x += v * 0.015 * uScale;
            uvOffset.y -= v * 0.003 * uScale;
            add += vec3(0.12, 0.17, 0.22) * v;
            rainSum += (1.0 - rainSum) * 0.75;
        }
    }

    vec4 texColor = flixel_texture2D(bitmap, uv + uvOffset);
    vec3 color = texColor.rgb;

    vec3 rainColor = vec3(0.4, 0.5, 0.8);
    color = mix(color + add, rainColor, 0.12 * rainSum * min(control, 1.0));

    gl_FragColor = vec4(color, texColor.a);
}