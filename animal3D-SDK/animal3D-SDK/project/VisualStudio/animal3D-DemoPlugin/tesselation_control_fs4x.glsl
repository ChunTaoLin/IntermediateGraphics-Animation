#version 410 core
layout(vertices = 3) out;
const int i = 5;
//in int gl_PatchVerticesIn;



////the out varying float value that will be passed to the fragment shader to determine color
//in float noiseValue;
//in vec4 tessPos;
//
//struct
//{
//
//    vec4 gl_Position;
//    float gl_PointSize;
//    float gl_ClipDistance[ 6 ];
//} gl_in[];
//

//in gl_PerVertex
//{
//  vec4 gl_Position;
//  float gl_PointSize;
//  float gl_ClipDistance[];
//} gl_in[gl_MaxPatchVertices];
//struct
//{
//vec4 gl_Position;
//float gl_PointSize;
//float gl_ClipDistance[ 6 ];
//} gl_out[ ];

//uniform mat4 uMVP;	// (1)


void main( )
{
  gl_out[ gl_InvocationID ].gl_Position = gl_in[ gl_InvocationID ].gl_Position;

  gl_TessLevelOuter[0] = float( 1 );
  gl_TessLevelOuter[1] = float( 5 );
}