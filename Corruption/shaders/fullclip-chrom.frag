// Automatically converted with https://github.com

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
uniform float beatPulse; // Fed dynamically by HScript!

// Dynamic uniforms updated via HScript
uniform float customBlur;           // Handles pure background blur
uniform float aberrationToggle;     // 0.0 = OFF (Clean), 1.0 = ON (Color Split)
uniform float shakeStrength;        // Controls maximum shake multiplier
uniform float aberrationIntensity;  // Controls RGB split intensity (1.0 = Default)
uniform float jitterAmount;         // Controls pulse erraticness/jitter (0.0 = Smooth, 1.0 = Very Jittery)

#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

// Quick pseudo-random generator
float hash(float n) {
    return fract(sin(n * 12.9898) * 43758.5453123);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;

    // 1. CONSTANT, FLUID SCREEN SHAKE (Driven by incoming beatPulse & shakeStrength)
    vec2 shake = vec2(0.0);
    float baseMod = (1.0 + beatPulse * 0.5) * shakeStrength;
    
    shake.x = sin(iTime * 45.0) * 0.0025 * baseMod; 
    shake.y = cos(iTime * 38.0) * 0.0018 * baseMod; 
    
    uv += shake;

    // 2. JITTERY PULSING CHROMATIC ABERRATION & BLUR
    float baselineBlur = customBlur; 
    
    // Fast time-based noise for erratic frame-by-frame jitter
    // Stepping time at 30fps gives a punchy, sharp retro jitter
    float stepTime = floor(iTime * 30.0);
    float noise = hash(stepTime);
    
    // Mix between smooth pulse and jittery noise based on jitterAmount uniform
    float jitterFactor = mix(1.0, 0.4 + noise * 1.2, jitterAmount);
    
    // Base pulse value scaled by intensity and jitter
    float pulsePeak = beatPulse * 0.02 * aberrationIntensity * jitterFactor;
    
    // Continuous sine-wave modulation
    float smoothBreathe = 0.8 + 0.2 * sin(iTime * 6.0);
    
    // Final aberration amount
    float aberrationAmount = pulsePeak * smoothBreathe * aberrationToggle;

    // Step A: Sample with chromatic aberration split
    vec3 col;
    col.r = texture( iChannel0, vec2(uv.x + aberrationAmount, uv.y + (aberrationAmount * 0.25)) ).r;
    col.g = texture( iChannel0, uv ).g;
    col.b = texture( iChannel0, vec2(uv.x - aberrationAmount, uv.y - (aberrationAmount * 0.25)) ).b;

    // Step B: Apply clean background blur
    vec3 blur1 = texture( iChannel0, vec2(uv.x + baselineBlur, uv.y + baselineBlur) ).rgb;
    vec3 blur2 = texture( iChannel0, vec2(uv.x - baselineBlur, uv.y - baselineBlur) ).rgb;
    vec3 blur3 = texture( iChannel0, vec2(uv.x + baselineBlur, uv.y - baselineBlur) ).rgb;
    vec3 blur4 = texture( iChannel0, vec2(uv.x - baselineBlur, uv.y + baselineBlur) ).rgb;
    
    vec3 cleanBlurCombine = (blur1 + blur2 + blur3 + blur4) * 0.25;
    col = mix(col, cleanBlurCombine, 0.65);

    col *= (1.0 - (aberrationAmount + baselineBlur) * 0.15);
    fragColor = vec4(col, texture(iChannel0, uv).a);
}

void main() {
    mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}