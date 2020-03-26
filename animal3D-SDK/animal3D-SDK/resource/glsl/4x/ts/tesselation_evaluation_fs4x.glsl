#version 410 core
const int foo = 3;
//
//struct
//{
//    vec4 gl_Position;
//    float gl_PointSize;
//    float gl_ClipDistance[ 6 ];
//} gl_in[ ];
//
//uniform mat4 uMVP;	// (1)
//
//out gl_PerVertex {
//  vec4 gl_Position;
//  float gl_PointSize;
//  float gl_ClipDistance[];
//};

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
//struct
//{
//    vec4 gl_Position;
//    float gl_PointSize;
//    float gl_ClipDistance[ 6 ];
//} gl_out[ ];
//

layout (triangles) in;

void main(void)
{
    vec4 p1 = mix(gl_in[1].gl_Position,gl_in[0].gl_Position,gl_TessCoord.x);
    vec4 p2 = mix(gl_in[2].gl_Position,gl_in[3].gl_Position,gl_TessCoord.x);
    gl_Position = mix(p1, p2, gl_TessCoord.y);
}