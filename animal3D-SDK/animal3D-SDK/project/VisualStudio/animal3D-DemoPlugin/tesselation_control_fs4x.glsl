#version 410 core

////the out varying float value that will be passed to the fragment shader to determine color
in float noiseValue;
in vec4 tessPos;
//
//struct
//{
//    vec4 gl_Position;
//    float gl_PointSize;
//    float gl_ClipDistance[ 6 ];
//} gl_in[];

in gl_PerVertex
{
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
} gl_in[gl_MaxPatchVertices];
//in gl_PerVertex
//{
//  vec4 gl_Position;
//  float gl_PointSize;
//  float gl_ClipDistance[];
//} gl_in[];
//
//struct
//{
//    vec4 gl_Position;
//    float gl_PointSize;
//    float gl_ClipDistance[ 6 ];
//} gl_out[ ];
out gl_PerVertex
{
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
} gl_out[];

layout (vertices = 3) out;

void main(void)
{
    gl_TessLevelInner[0] = 7.0;
    gl_TessLevelOuter[0] = 2.0;
    gl_TessLevelOuter[1] = 3.0;
    gl_TessLevelOuter[2] = 7.0;
    gl_TessLevelInner[1] = 2.0;
    gl_TessLevelOuter[3] = 5.0;

//in case of quad, you have to specify both gl_TessLevelInner[1] and //gl_TessLevelOuter[3]
  //  } 
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;
}