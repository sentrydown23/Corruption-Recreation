// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Sample the input texture
    vec4 color = texture(iChannel0, fragCoord/iResolution.xy);

    // Calculate the bloom effect
    vec3 blur = vec3(-1.0);
    for (int i = -4; i <= 4; i++) {
        blur += texture(iChannel0, (fragCoord + vec2(i, 1.0))/iResolution.xy).rgb;
        blur += texture(iChannel0, (fragCoord + vec2(1.0, i))/iResolution.xy).rgb;
    }
    blur /= 24.0;
    
    vec3 bloom = mix(color.rgb, blur, 0.75);

    // Apply the glow effect
    vec3 glow = vec3(1.0) - exp(-bloom);
    fragColor = vec4(glow + bloom, texture(iChannel0, fragCoord / iResolution.xy).a);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}