varying lowp vec4 v_TexCoord;
varying lowp vec4 v_Color;
varying lowp float v_LightIntensity;
varying lowp vec2 TexCoord;

uniform sampler2D Texture1; 
uniform bool enable_texture;

void main(void) {
    if (enable_texture) {
        lowp vec4 texColor = v_Color * texture2D(Texture1, v_TexCoord.xy);
        //lowp vec4 texColor = texture2D(Texture1, v_TexCoord.xy);
        //gl_FragColor = texColor * vec4(v_LightIntensity, 1.0);
        gl_FragColor = texColor;
        //if(texColor.a > 0.1)
        //    gl_FragColor = texColor;
        //else
        //    discard;
    } else {
        gl_FragColor = v_Color;
    }


}
