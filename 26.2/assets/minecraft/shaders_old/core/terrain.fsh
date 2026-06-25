#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:light.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;

in vec4 lightColor;
in vec2 texCoord;
in vec2 texCoord2;
in vec3 Pos;
in float transition;

flat in int isCustom;
flat in int noshadow;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord);
    float t = clamp(transition, 0.0, 1.0);
    if (t > 0.0) {
        vec4 color2 = texture(Sampler0, texCoord2);
        color = mix(color, color2, t);
    }

    //custom lighting
    #define BLOCK
    #moj_import<objmc_light.glsl>
    
#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
