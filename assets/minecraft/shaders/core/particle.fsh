#version 330

#moj_import <minecraft:utils.glsl>
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;

    // Discards vertexColor (tint) on obsidian tear particles
    float alpha = textureLod(Sampler0, texCoord0, 0.0).a * 255.0;
    if (check_alpha(alpha, 250.0)) {
        color = texture(Sampler0, texCoord0) * ColorModulator;
        color.a = 1;
    }
    // Multiplies color for antigravity particles
    else if (check_alpha(alpha, 249.0)) {
        vec4 antiGravityColor = vec4(66/255., 29/255., 208/255., 1);
        color = texture(Sampler0, texCoord0) * antiGravityColor * ColorModulator;
        color.a = 1;
    }

    if (color.a < 0.1) {
        discard;
    }
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}