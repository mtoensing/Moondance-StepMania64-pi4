attribute vec4 Position;
attribute vec4 SourceColor;
attribute vec2 TexCoord;
attribute vec3 Normal;
 
varying vec4 v_Color;
varying vec4 v_TexCoord;
varying float v_LightIntensity;

uniform mat4 Projection;
uniform mat4 Modelview;
uniform mat4 Texture;
uniform mat3 WorldViewIT;
uniform vec3 LightDir;
uniform bool enable_lighting;
 
void main(void) {
    v_Color = SourceColor;
    v_TexCoord = Texture * vec4(TexCoord, 1.0, 1.0);
    
    if (enable_lighting) {
        mediump vec3 normal = normalize(WorldViewIT * Normal);
        v_LightIntensity = max(0.0, dot(normal, LightDir));
    } else {
        v_LightIntensity = 1.0;
    }

    gl_Position = Projection * Modelview * Position;
}

