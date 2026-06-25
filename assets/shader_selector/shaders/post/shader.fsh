#version 330

uniform sampler2D MainSampler;
uniform sampler2D DataSampler;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

#moj_import <minecraft:globals.glsl>

#moj_import <shader_selector:marker_settings.glsl>
#moj_import <shader_selector:utils.glsl>
#moj_import <shader_selector:data_reader.glsl>

in vec2 texCoord;

float Frequency = 1;
float Intensity = 0.7;

out vec4 fragColor;

void main() {
    fragColor = texture(MainSampler, texCoord);

    // Color Matrix
    vec3 RedMatrix = vec3(1, 0.0, 0.0);
    float RedValue = dot(fragColor.rgb, RedMatrix);
    vec4 OutColor = vec4(RedValue, 0, 0, 1.0);

    // Pulse Color Output
    float pulse = Intensity * (1-cos(readChannel(RED_ALERT_CHANNEL) * 100000 * Frequency * 3.1415926535)) / 2;
    OutColor.rgb = mix(fragColor.rgb, OutColor.rgb, pulse);

    fragColor = OutColor;

// #define DEBUG
#ifdef DEBUG
    // Show data sampler on screen
    if (texCoord.x < .25 && texCoord.y < .25) {
        vec2 uv = texCoord * 4.0;
        vec4 col = texture(DataSampler, uv);
        if (uv.x > 1./5.)
            col = vec4(vec3(fract(decodeColor(col))), 1.0);
        fragColor = col;
    }
#endif
}