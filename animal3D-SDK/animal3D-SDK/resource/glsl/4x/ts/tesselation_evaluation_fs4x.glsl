#version 410 core
const int foo = 3;
layout (quads) in;
//struct
//{
//    vec4 gl_Position;
//    float gl_PointSize;
//    float gl_ClipDistance[ 6 ];
//} gl_in[ ];

//uniform mat4 uMVP;	// (1)
//
void main()
{
	// DUMMY OUTPUT: directly assign input position to output position
//	gl_Position = aPosition;
//	vec4 newPos = vec4(0,0,0,1);
   // noiseValue = calculatePerlinNoise(newPos.xyz);
   // newPos.a += calculatePerlinNoise(newPos.xyz);
   // tessPos = newPos;
   //gl_Position = uMVP * newPos;	// (2)
}