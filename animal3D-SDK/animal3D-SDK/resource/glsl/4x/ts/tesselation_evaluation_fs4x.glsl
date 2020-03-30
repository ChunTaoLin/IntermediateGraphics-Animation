#version 410 core

// Input patch
in gl_PerVertex
{
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
} gl_in[gl_MaxPatchVertices];

// Output Vertex
out gl_PerVertex {
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
};

// This function interpolates a given float
float interpolate1D(float v0, float v1, float v2) 
{
    return float(gl_TessCoord.x) * v0 + float(gl_TessCoord.y) * v1 + float(gl_TessCoord.z) * v2;
}

layout(triangles) in;

// Take in noise value from TC
in float aNoiseValES[];

// Output noise value to GS
out float aNoiseValFS;

void main(void)
{

    //Interpolate noise values from TC
    aNoiseValFS = interpolate1D(aNoiseValES[0], aNoiseValES[1], aNoiseValES[2]);

    //Mix and set actual positions
    vec4 p1 = mix(gl_in[1].gl_Position,gl_in[0].gl_Position,gl_TessCoord.x);
    vec4 p2 = mix(gl_in[2].gl_Position,gl_in[3].gl_Position,gl_TessCoord.x);
    gl_Position = mix(p1, p2, gl_TessCoord.y);
}