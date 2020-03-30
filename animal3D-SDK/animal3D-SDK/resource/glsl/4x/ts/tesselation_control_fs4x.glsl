#version 410 core

in gl_PerVertex
{
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
} gl_in[gl_MaxPatchVertices];

out gl_PerVertex
{
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
} gl_out[];

// define the number of CPs in the output patch
layout (vertices = 3) out;

//layout (vertices = 3) out;
//layout (location = 8) in vec4 stuff;
in vec2 aCSTexCoord[];
out vec2 aESTexCoord[];
in float aNoiseValCS[];
out float aNoiseValES[];


void main(void)
{
    aESTexCoord[gl_InvocationID] = aCSTexCoord[gl_InvocationID];
    aNoiseValES[gl_InvocationID] = aNoiseValCS[gl_InvocationID];
    gl_TessLevelInner[0] = 0.5;
    gl_TessLevelOuter[0] = 0.5;
    gl_TessLevelOuter[1] = 0.5;
    gl_TessLevelOuter[2] = 0.5;

//in case of quad, you have to specify both gl_TessLevelInner[1] and //gl_TessLevelOuter[3]
  //  } 
   gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;
}