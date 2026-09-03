#version 330

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:sample_lightmap.glsl>
#endif

#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
in ivec2 UV2;
#endif

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
uniform sampler2D Sampler2;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;
#endif

out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = Color * sample_lightmap(Sampler2, UV2);
#else
    vertexColor = Color;
#endif
    texCoord0 = UV0;

// custom text colors
#if defined(IS_GUI)
    // speedrun timer
    else if (Color == vec4(172/255., 168/255., 0, Color.a)) {
        // nudge it some
        vec3 newPos = vec3(Position.x - 21.0, Position.y - 38.0, Position.z);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // move to top right corner
        gl_Position.x += gl_Position.w;

        // recolor to white
        vertexColor.rgb = vec3(1.0);
    }
    
    // speedrun timer shadow 
    else if (Color == vec4(43/255., 42/255., 0, Color.a)) {
        // nudge it some
        vec3 newPos = vec3(Position.x - 21.0, Position.y - 38.0, Position.z);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // move to top right corner
        gl_Position.x += gl_Position.w;

        // recolor to dark gray
        vertexColor.rgb = vec3(0.25);
    }
#endif
}