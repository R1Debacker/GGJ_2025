shader_type canvas_item;

uniform float blur_size : hint_range(0.0, 10.0) = 0;

void fragment() {
    vec2 tex_size = TEXTURE_PIXEL_SIZE * blur_size;
    vec4 sum = vec4(0.0);

    // 9-Tap Gaussian Blur
    sum += texture(TEXTURE, UV + vec2(-tex_size.x, -tex_size.y)) * 0.05;
    sum += texture(TEXTURE, UV + vec2( tex_size.x, -tex_size.y)) * 0.05;
    sum += texture(TEXTURE, UV + vec2(-tex_size.x,  tex_size.y)) * 0.05;
    sum += texture(TEXTURE, UV + vec2( tex_size.x,  tex_size.y)) * 0.05;
    sum += texture(TEXTURE, UV + vec2(-tex_size.x, 0.0)) * 0.1;
    sum += texture(TEXTURE, UV + vec2( tex_size.x, 0.0)) * 0.1;
    sum += texture(TEXTURE, UV + vec2(0.0, -tex_size.y)) * 0.1;
    sum += texture(TEXTURE, UV + vec2(0.0,  tex_size.y)) * 0.1;
    sum += texture(TEXTURE, UV) * 0.4;

    COLOR = sum;
}
