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
	
	drawLambert_multi_mrt_fs4x.glsl
	Draw Lambert shading model for multiple lights with MRT output.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Lambert shading model
//	Note: test all data and inbound values before using them!
//	5) set location of final color render target (location 0)
//	6) declare render targets for each attribute and shading component

layout (location = 0) out vec4 finalColorRenderTarget;
layout (location = 1) out vec4 renderTargetViewPos;
layout (location = 2) out vec4 renderTargetNormal;
layout (location = 3) out vec4 renderTargetTexCoord;
layout (location = 4) out vec4 renderTargetDiffuseMap;
//layout (location = 5) out vec4 renderTargetSpecularMap;
layout (location = 6) out vec4 renderTargetDiffuseTotal;
//layout (location = 7) out vec4 renderTargetSpecularTotal;
//layout (location = 8) out vec4 renderTargetDepthBuffer;
//out vec4 renderTarget;
//out vec4 renderTargetDiffuseTotal;
//out vec4 
//out vec4 renderTargetTexCoord;
vec4 renderTargetSpecularMap;
vec4 renderTargetSpecularTotal;
//
// Texture Values
uniform sampler2D uTex_dm;
layout (location = 8) in vec4 aTexCoord;

// Lighting Values
uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];
uniform int uLightCt;

// Transform Values
in vec4 passViewPosition;
layout (location = 2) in vec4 mVNormal;

// Magnification Values
float diffuseMagnifier = 1;

out vec4 rtFragColor;





// This function calculates the lighting vector based on a given position and light position
vec4 CalculateLightVector(vec4 position, vec4 lightPos) 
{
	vec4 lightNorm = lightPos - position;
	return normalize(lightNorm);
}





// This function calculates the lambertian product based on a surface normal and lighting normal
float CalculateLambertianProduct(vec4 surfaceNormal, vec4 lightNormal) 
{
	return dot(surfaceNormal,lightNormal);
}





void main()
{
	// Calculate all Lambert shading values for each light
	vec4 mixedColors = uLightCol[0] * min(max((uLightCt - 0),0),1) * CalculateLambertianProduct(mVNormal, CalculateLightVector(passViewPosition,uLightPos[0]));
	mixedColors += uLightCol[1] * min(max((uLightCt - 1),0),1) * CalculateLambertianProduct(mVNormal, CalculateLightVector(passViewPosition,uLightPos[1]));
	mixedColors += uLightCol[2] * min(max((uLightCt - 2),0),1) * CalculateLambertianProduct(mVNormal, CalculateLightVector(passViewPosition,uLightPos[2]));
	mixedColors += uLightCol[3] * min(max((uLightCt - 3),0),1) *CalculateLambertianProduct(mVNormal, CalculateLightVector(passViewPosition,uLightPos[3]));

	// Texture to point
	vec4 originalTex = texture(uTex_dm, aTexCoord.xy); 

	// Add color of finalized diffuse
	rtFragColor = diffuseMagnifier * mixedColors * originalTex;
	rtFragColor = vec4(rtFragColor.x,rtFragColor.y,rtFragColor.z,1.0);


	renderTargetViewPos = passViewPosition;
	renderTargetNormal = mVNormal * passViewPosition;
	renderTargetTexCoord = aTexCoord;
	renderTargetDiffuseMap = originalTex;
	renderTargetSpecularMap = vec4(0.0,0.0,0.0,0.0);
	renderTargetDiffuseTotal = diffuseMagnifier * mixedColors;
	renderTargetSpecularTotal = vec4(0.0,0.0,0.0,0.0);
	//final color
	finalColorRenderTarget = rtFragColor;
}
