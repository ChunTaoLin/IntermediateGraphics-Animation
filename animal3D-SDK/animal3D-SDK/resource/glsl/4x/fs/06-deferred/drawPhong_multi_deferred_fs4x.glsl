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
	
	drawPhong_multi_deferred_fs4x.glsl
	Draw Phong shading model by sampling from input textures instead of 
		data received from vertex shader.
*/

#version 410

#define MAX_LIGHTS 4

// ****TO-DO: 
//	0) copy original forward Phong shader
//	1) declare g-buffer textures as uniform samplers
//	2) declare light data as uniform block
//	3) replace geometric information normally received from fragment shader 
//		with samples from respective g-buffer textures; use to compute lighting
//			-> position calculated using reverse perspective divide; requires 
//				inverse projection-bias matrix and the depth map
//			-> normal calculated by expanding range of normal sample
//			-> surface texture coordinate is used as-is once sampled

// Texture Values
uniform sampler2D uImage00;//depth buffer
//g buffers
uniform sampler2D uImage01;//position
uniform sampler2D uImage02;//normal
uniform sampler2D uImage03;//texcoord
uniform sampler2D uImage04;//diffuse
uniform sampler2D uImage05;//specular
uniform sampler2D uImage06;//shadowmap
uniform sampler2D uImage07;//earth tex

uniform mat4 uPB;
uniform mat4 uPB_inv;

// Light Values
uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];
uniform int uLightCt;

// Transform Values
in vec4 passViewPosition;
layout (location = 2) in vec4 mVNormal;

// Magnification Values
float specularMagnifier = .4;
float shininess = 2;
float diffuseMagnifier = 0.5;

//Phong Values
float lambertianProduct;
float specularProduct;
float ambiance = 0.01;

in vec4 vTexcoord;
in vec4 vViewNormal;

layout (location = 0) out vec4 rtFragColor;
layout (location = 1) out vec4 rtViewPos;
layout (location = 2) out vec4 rtViewNormal;
layout (location = 3) out vec4 rtAtlasCoord;
layout (location = 4) out vec4 rtDiffuseMapSample;
layout (location = 5) out vec4 rtSpecularMapSample;
layout (location = 6) out vec4 rtDiffuseLightTotal;
layout (location = 7) out vec4 rtSpecularLightTotal;


// This function calculates the light vector from a given view position and light position
vec4 CalculateLightVector(vec4 position, vec4 lightPos) 
{
	vec4 lightNorm = lightPos - position;
	return normalize(lightNorm);
}





// This function calculates the lambertian product from a given surface normal and light normal
float CalculateLambertianProduct(vec4 surfaceNormal, vec4 lightNormal) 
{
	return dot(surfaceNormal,lightNormal);
}





// This function calculates the specular coefficient from a given surface normal, view position, perspective point, and light normal
float CalculateSpecularCoefficient(vec4 surfaceNormal, vec4 viewPos, vec4 perspectivePoint, vec4 lightingNormal)
{
	vec4 specular =  normalize(perspectivePoint - viewPos);

	vec4 reflection = (2 * (dot(surfaceNormal,lightingNormal)) * surfaceNormal) - lightingNormal;

	float endCoefficient = max(0.0, pow(dot(-specular, reflection),shininess));
	return endCoefficient;
}


void main()
{
	rtFragColor = vec4(0.0, 1.0, 1.0, 1.0);
	vec4 newCoord = texture(uImage03, vTexcoord.xy);
	vec4 dm = texture(uImage04, newCoord.xy);
	vec4 sm = texture(uImage05,newCoord.xy);
	float depth = texture(uImage00, vTexcoord.xy).x;
	vec4 vNormal = texture(uImage02,vTexcoord.xy);

	//depth buffer
	rtFragColor = vec4(0.0, 1.0, 1.0, 1.0);

	//View Pos G buffer
	rtViewPos = vec4(vTexcoord.xy, depth,1.0);
	rtViewPos = uPB_inv * rtViewPos;
	rtViewPos /= rtViewPos.a;

	//Normal G buffer NEEDS TWEAKING
	rtViewNormal = texture(uImage02,vTexcoord.xy);

	//Texcoord/atlastexcoord G buffer
	rtAtlasCoord = texture(uImage03,vTexcoord.xy);

	//Diffuse Map Sample G buffer
	rtDiffuseMapSample = dm;

	//Specular Map Sample G buffer
	rtSpecularMapSample = sm;

	// Point of the viewer
	vec4 perspectivePosition = vec4(0,0,0,1);

	// Make texture color
	vec4 originalTex = texture(uImage04, newCoord.xy); 

	vec4 mixedColors = vec4(0);

	float diffuseTotal;
	float specularTotal;
	vec4 spec;

	// Phong shading for Lights
	for(int i = 0; i < 4; i++)
	{
		specularProduct = min(max((uLightCt - i),0),1) * specularMagnifier * CalculateSpecularCoefficient(vNormal,rtViewPos, perspectivePosition,  CalculateLightVector(rtViewPos,uLightPos[i]));
		lambertianProduct = min(max((uLightCt - i),0),1) * diffuseMagnifier * CalculateLambertianProduct(vNormal, CalculateLightVector(rtViewPos,uLightPos[i]));
		mixedColors += uLightCol[i] * lambertianProduct + specularProduct + (min(max((uLightCt - i),0),1) * ambiance);
		diffuseTotal += lambertianProduct;
		specularTotal += specularProduct;
		spec += specularProduct * uLightCol[i];
	}

	// Calculate the specular light total and the diffuse light total
	rtSpecularLightTotal = specularTotal  * spec * specularMagnifier + vec4(0.0,0.0,0.0,1.0) ;
	rtDiffuseLightTotal = diffuseTotal + mixedColors;

	// Return final color
	rtFragColor = originalTex * mixedColors;
}