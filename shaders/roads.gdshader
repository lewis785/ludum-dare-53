shader_type canvas_item;

uniform sampler2D texture;

void vertex() {
    // Calculate texture coordinates based on the position of each vertex in the line.
    vec2 texcoord = vec2(VERTEX.x, 0.1);

    // Pass the texture coordinates to the fragment shader.
    UV = texcoord;
}

void fragment() {
    // Sample the texture using the UV attribute.
    vec4 texColor = texture(texture, UV);

    // Multiply the line color by the texture color.
    COLOR.rgb *= texColor.rgb;
}