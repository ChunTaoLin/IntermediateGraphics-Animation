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
	
	drawLightingData_fs4x.glsl
	Draw attribute data received from vertex shader directly to targets.
*/

#version 410

// ****TO-DO: 
//	1) declare varyings to receive attribute data
//	2) declare render targets to display attribute data
//	3) copy attribute data from varying to respective render targets, 
//		transforming data accordingly

/*
since our shader does not actually calculate lighting, use the other targets for attributes.  See the HUD for the named g-buffers (we've been implicitly using them all along).
This shader is very short; you should not be doing anything other than outputting attributes in view space, as received from the vertex shader; normalize and compress as needed.

*/
layout (location = 1) out vec4 rtViewPosition;
layout (location = 2) out vec4 rtViewNormal;
layout (location = 3) out vec4 rtAtlasTexcoord;
layout (location = 4) out vec4 rtDiffuseSample;

uniform sampler2D uImage04;

in vbLightingData {
	vec4 vViewPosition;
	vec4 vViewNormal;
	vec4 vTexcoord;
	vec4 vBiasedClipCoord;
};

void main()
{
	rtViewPosition = vViewPosition ;
	rtViewNormal = normalize(vViewNormal);
	rtAtlasTexcoord = vTexcoord;
	//This essentially clamps the normal to 0-1
	rtDiffuseSample = normalize(vViewNormal * 0.5 + 0.5);
}
