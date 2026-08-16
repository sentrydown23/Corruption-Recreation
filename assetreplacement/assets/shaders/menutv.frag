// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

// Pseudo-random helpers
float rand(float n) {
    return fract(sin(n) * 43758.5453);
}
float rand2(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    // --- PARAMETERS ---
    float CA_AMOUNT   = 0.004;
    float SCAN_FREQ   = 800.0;
    float SCAN_DEPTH  = 0.15;
    float GRAIN_AMT   = 0.06;
    float VIGN_SIZE   = 0.4;
    float VIGN_SOFT   = 0.5;

    // GLITCH --- timing parameters (tuned for quick, rare, sporadic pops)
    float GLITCH_RATE  = 0.08;   // lower rate: much less frequent
    float GLITCH_CA    = 0.03;   // extra CA during glitch
    float GLITCH_BANDS = 12.0;   // finer slice bands for sharper pop
    float GLITCH_SHIFT = 0.03;   // horizontal pixel-row shift
    float GLITCH_BLOCK = 0.05;   // chance of a full-black dropout block

    // GLITCH --- high-frequency time seed so glitches pass in a split-second frame
    // floor(iTime * 15.0) evaluates 15 distinct ticks per second
    float timeSeed = floor(iTime * 15.0);

    // Is a glitch event happening right now?
    float glitchOn = step(1.0 - GLITCH_RATE, rand(timeSeed));

    // GLITCH --- horizontal row shift
    // Divide screen into bands. Each band gets an independent random shift.
    float band     = floor(uv.y * GLITCH_BANDS);
    float rowSeed  = rand(band + timeSeed * 13.7);
    float shift    = (rowSeed - 0.5) * 2.0 * GLITCH_SHIFT * glitchOn;
    vec2 shiftedUV = vec2(uv.x + shift, uv.y);

    // GLITCH --- chromatic aberration burst
    // On a glitch frame, CA_AMOUNT jumps to GLITCH_CA for some bands
    float caBoost  = step(0.5, rand(band * 3.1 + timeSeed)) * glitchOn;
    float ca       = CA_AMOUNT + GLITCH_CA * caBoost;

    // 1. CHROMATIC ABERRATION (uses shifted UV + boosted CA)
    vec2 offset = (shiftedUV - 0.5) * ca;
    float r = texture(iChannel0, shiftedUV + offset).r;
    float g = texture(iChannel0, shiftedUV        ).g;
    float b = texture(iChannel0, shiftedUV - offset).b;
    vec3 col = vec3(r, g, b);

    // GLITCH --- full-black dropout blocks
    // Some bands randomly black out entirely during a glitch
    float dropout = step(1.0 - GLITCH_BLOCK, rand2(vec2(band, timeSeed))) * glitchOn;
    col *= 1.0 - dropout;

    // GLITCH --- horizontal bright tear line
    // A single-pixel-wide white line at a random Y position
    float tearY    = rand(timeSeed * 7.3);
    float tearLine = step(0.998, 1.0 - abs(uv.y - tearY)) * glitchOn;
    col += vec3(tearLine * 0.8);

    // 2. SCANLINES
    float scan = sin(uv.y * SCAN_FREQ) * 0.5 + 0.5;
    scan = pow(scan, 0.8);
    col *= 1.0 - (1.0 - scan) * SCAN_DEPTH;

    // 3. NOISE GRAIN
    vec2 seed = uv + fract(iTime * 0.1);
    float noise = fract(sin(dot(seed, vec2(12.9898, 78.233))) * 43758.5453);
    col += (noise - 0.5) * GRAIN_AMT;

    // 4. VIGNETTE
    float dist = length(uv - 0.5);
    float vign = smoothstep(VIGN_SIZE + VIGN_SOFT, VIGN_SIZE, dist);
    col *= vign;

    fragColor = vec4(col, texture(iChannel0, fragCoord / iResolution.xy).a);
}

void main() {
    mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}