shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(1.0, 0.0, 1.0, 1.0); // Pink
uniform vec4 color2 : source_color = vec4(0.0, 1.0, 1.0, 1.0); // Cyan
uniform vec4 color3 : source_color = vec4(1.0, 1.0, 1.0, 1.0); // White
uniform vec4 color4 : source_color = vec4(0.0, 1.0, 1.0, 1.0); // Cyan again
uniform vec4 color5 : source_color = vec4(1.0, 0.0, 1.0, 1.0); // Pink again

void fragment() {
    float x = UV.x; // 0.0 to 1.0 across the text's width
    vec4 gradient_color;

    if (x < 0.25) {
        float t = x / 0.25;
        gradient_color = mix(color1, color2, t);
    } else if (x < 0.5) {
        float t = (x - 0.25) / 0.25;
        gradient_color = mix(color2, color3, t);
    } else if (x < 0.75) {
        float t = (x - 0.5) / 0.25;
        gradient_color = mix(color3, color4, t);
    } else {
        float t = (x - 0.75) / 0.25;
        gradient_color = mix(color4, color5, t);
    }

    COLOR = texture(TEXTURE, UV) * gradient_color;
}
