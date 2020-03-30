#version 430

in gl_PerVertex
{
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
} gl_in[];
//
out gl_PerVertex
{
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
};

//take in triangles and output will be strip triangles with max of 3 vertices to show triangles
layout(triangles) in;
layout(triangle_strip, max_vertices= 3) out;

in float aNoiseValFS[];
out float aFSNoiseVal;

void main() 
{
    aFSNoiseVal = aNoiseValFS[0] + aNoiseValFS[1] + aNoiseValFS[2];
	for(int i= 0; i< 3; ++i) 
	{
	    gl_Position =  gl_in[i].gl_Position;     
    EmitVertex();
	}EndPrimitive();				
}