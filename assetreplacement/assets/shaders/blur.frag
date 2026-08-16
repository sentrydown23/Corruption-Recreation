#pragma header

#define iChannel0 bitmap
#define texture flixel_texture2D

uniform float uBlur; // Controlled by your HScript 'blurAmount'

void main() {
    vec2 uv = openfl_TextureCoordv;

    // Early exit if blur is disabled/zeroed
    if (uBlur <= 0.0) {
        gl_FragColor = texture(iChannel0, uv);
        return;
    }

    // Scale offset factor so 1.0 - 5.0 range gives visible screen-wide blurring
    float offset = uBlur * 0.0025;

    // Direct offset sampling (based on reference shader technique)
    vec4 col = texture(iChannel0, uv) * 0.2; // Center sample

    // 4 Diagonal offsets
    col += texture(iChannel0, vec2(uv.x + offset, uv.y + offset)) * 0.15;
    col += texture(iChannel0, vec2(uv.x - offset, uv.y - offset)) * 0.15;
    col += texture(iChannel0, vec2(uv.x + offset, uv.y - offset)) * 0.15;
    col += texture(iChannel0, vec2(uv.x - offset, uv.y + offset)) * 0.15;

    // 4 Cross offsets (widens the blur uniformly across the entire screen)
    col += texture(iChannel0, vec2(uv.x + offset, uv.y)) * 0.05;
    col += texture(iChannel0, vec2(uv.x - offset, uv.y)) * 0.05;
    col += texture(iChannel0, vec2(uv.x, uv.y + offset)) * 0.05;
    col += texture(iChannel0, vec2(uv.x, uv.y - offset)) * 0.05;

    gl_FragColor = vec4(col.rgb, texture(iChannel0, uv).a);
}