#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

float vertJerkOpt = 0.0;     // Force disabled
float vertMovementOpt = 0.0; // Force disabled
float bottomStaticOpt = 1.0;
float scalinesOpt = 1.0;
float rgbOffsetOpt = 1.0;
float horzFuzzOpt = 1.0;

vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(((x*34.0)+1.0)*x); }

float snoise(vec2 v) {
    const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
    vec2 i  = floor(v + dot(v, C.yy) );
    vec2 x0 = v -   i + dot(i, C.xx);
    vec2 i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = mod289(i);
    vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0 )) + i.x + vec3(0.0, i1.x, 1.0 ));
    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
    m = m*m; m = m*m;
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

float staticV(vec2 uv) {
    float staticHeight = snoise(vec2(9.0, iTime*1.2+3.0))*0.3+5.0;
    float staticAmount = snoise(vec2(1.0, iTime*1.2-6.0))*0.1+0.3;
    float staticStrength = snoise(vec2(-9.75, iTime*0.6-3.0))*2.0+2.0;
    return (1.0-step(snoise(vec2(5.0*pow(iTime,2.0)+pow(uv.x*7.0,1.2),pow((mod(iTime,100.0)+100.0)*uv.y*0.3+3.0,staticHeight))),staticAmount))*staticStrength;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = fragCoord.xy/iResolution.xy;
    
    float fuzzOffset = snoise(vec2(iTime*15.0,uv.y*80.0))*0.0005;
    float largeFuzzOffset = snoise(vec2(iTime*1.0,uv.y*25.0))*0.0008;
    
    // Completely removed the jerk math additions to stabilize vertical layout
    float y = uv.y;
    
    float xOffset = (fuzzOffset + largeFuzzOffset) * horzFuzzOpt;
    
    float staticVal = 0.0;
    for (float offsetY = -1.0; offsetY <= 1.0; offsetY += 1.0) {
        float maxDist = 5.0/200.0;
        float dist = offsetY/200.0;
        staticVal += staticV(vec2(uv.x,uv.y+dist))*(maxDist-abs(dist))*1.5;
    }
    staticVal *= bottomStaticOpt * 0.2;
    
    // Boosted RGB channel split separation up slightly (0.002 -> 0.005)
    float red   = texture(iChannel0, vec2(uv.x + xOffset -0.005*rgbOffsetOpt,y)).r+staticVal;
    float green = texture(iChannel0, vec2(uv.x + xOffset,      y)).g+staticVal;
    float blue  = texture(iChannel0, vec2(uv.x + xOffset +0.005*rgbOffsetOpt,y)).b+staticVal;
    
    vec3 color = vec3(red,green,blue);
    float scanline = sin(uv.y*800.0)*0.04*scalinesOpt;
    color -= scanline;
    
    fragColor = vec4(color, texture(iChannel0, fragCoord / iResolution.xy).a);
}

void main() {
    mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}
