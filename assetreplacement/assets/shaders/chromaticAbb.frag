#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D

uniform float strength;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    float ChromaticAberration = strength;
    vec2 uv = fragCoord.xy / iResolution.xy;

    vec2 texel = 1.0 / iResolution.xy;
    
    vec2 coords = (uv - 0.5) * 2.0;
    float coordDot = dot(coords, coords);
    
    vec2 precompute = ChromaticAberration * coordDot * coords;
    vec2 uvR = uv - texel.xy * precompute;
    vec2 uvB = uv + texel.xy * precompute;
    
    vec4 color;
    color.r = texture(iChannel0, uvR).r;
    color.g = texture(iChannel0, uv).g;
    color.b = texture(iChannel0, uvB).b;
    color.a = texture(iChannel0, uv).a;
    
    fragColor = color;
}

void main() {
    mainImage(gl_FragColor, openfl_TextureCoordv * openfl_TextureSize);
}