	/*
	Copyright 2011-2020 Daniel S. Buckstein

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

/*
	animal3D SDK: Minimal 3D Animation Framework
	By Daniel S. Buckstein
	
	drawCurveSegment_gs4x.glsl
	Draw curve segment based on waypoints being passed from application.
*/

#version 430

// (16 samples/segment * 1 segment + 4 samples/handle * 2 handles)
#define MAX_VERTICES 24

#define MAX_WAYPOINTS 32

//
//struct
//{
//    vec4 gl_Position;
//    float gl_PointSize;
//    float gl_ClipDistance[ 6 ];
//} gl_in[ ];
//
//
//struct
//{
//    vec4 gl_Position;
//    float gl_PointSize;
//    float gl_ClipDistance[ 6 ];
//} gl_out[ ];
//
layout(triangles) in;
layout(triangle_strip, max_vertices= 3) out;

void main() 
{
	for(int i= 0; i< 3; ++i) {
		gl_Position = gl_in[i].gl_Position;
		EmitVertex();
		}EndPrimitive();
}

