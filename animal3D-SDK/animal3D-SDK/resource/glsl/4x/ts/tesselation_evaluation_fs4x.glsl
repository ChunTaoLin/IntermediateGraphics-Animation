#version 410 core

in gl_PerVertex
{
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
} gl_in[gl_MaxPatchVertices];


out gl_PerVertex {
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
};

vec2 interpolate2D(vec2 v0, vec2 v1, vec2 v2)
{
    return vec2(gl_TessCoord.x) * v0 + vec2(gl_TessCoord.y) * v1 + vec2(gl_TessCoord.z) * v2;
}

float interpolate1D(float v0, float v1, float v2) 
{
    return float(gl_TessCoord.x) * v0 + float(gl_TessCoord.y) * v1 + float(gl_TessCoord.z) * v2;
}

layout(triangles) in;

// Take in tex coord and noise value from TC
in vec2 aESTexCoord[];
in float aNoiseValES[];

// Output tex coord and noise value to GS
out vec2 aGSTexCoord[];
out float aNoiseValFS;

void main(void)
{

    //Set the array content so it can be passed to GS
    aGSTexCoord[0] = aESTexCoord[0];
    aGSTexCoord[1] = aESTexCoord[1];
    aGSTexCoord[2] = aESTexCoord[2];

    //Interpolate noise values from TC
    aNoiseValFS = interpolate1D(aNoiseValES[0], aNoiseValES[1], aNoiseValES[2]);

    //Mix and set actual positions
    vec4 p1 = mix(gl_in[1].gl_Position,gl_in[0].gl_Position,gl_TessCoord.x);
    vec4 p2 = mix(gl_in[2].gl_Position,gl_in[3].gl_Position,gl_TessCoord.x);
    gl_Position = mix(p1, p2, gl_TessCoord.y);
}