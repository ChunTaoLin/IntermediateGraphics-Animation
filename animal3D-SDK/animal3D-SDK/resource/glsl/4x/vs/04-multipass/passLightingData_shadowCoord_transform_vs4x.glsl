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
	
	passLightingData_shadowCoord_transform_vs4x.glsl
	Vertex shader that prepares and passes lighting data. Outputs transformed 
		position attribute and all others required for lighting. Also computes 
		and passes shadow coordinate.
*/

#version 410

// ****TO-DO: 
//	0) copy previous lighting data vertex shader
//	1) declare MVPB matrix for light
//	2) declare varying for shadow coordinate
//	3) calculate and pass shadow coordinate

// Uniforms
uniform mat4 uMV;
uniform mat4 uP;
uniform mat4 uMV_nrm;
uniform mat4 uAtlas;
uniform mat4 uMVPB_other;

// Transform Values
layout (location = 0) in vec4 aPosition;
layout (location = 2) in vec4 oldNormal;
layout (location = 2) out vec4 newNormal;
out vec4 passViewPosition;

// Texture values
layout (location = 8) in vec4 aTexCoord;
layout (location = 8) out vec4 aTexCoordOut;

// Shading values
out vec4 aShadowCoordOut;

void main()
{
	// Transform texture Coordinates by Atlas matrix 
	aTexCoordOut = aTexCoord * uAtlas;

	// Transform the position into view space
	passViewPosition = uMV * aPosition;

	// Get new normal by transforming it by the uMV_nrm matrix
	newNormal = normalize(uMV_nrm * oldNormal);

	// Calculate shadow coordinate
	aShadowCoordOut = uMVPB_other * aPosition;

	//Return the view space position into clip space
	gl_Position =  uP * passViewPosition;
}
