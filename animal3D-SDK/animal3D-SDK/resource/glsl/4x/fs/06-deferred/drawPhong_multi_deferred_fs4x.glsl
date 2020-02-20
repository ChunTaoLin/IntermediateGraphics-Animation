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
uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;

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



layout (location = 8) in vec4 aTexCoord;

layout (location = 0) out vec4 rtFragColor;
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
	// DUMMY OUTPUT: all fragments are OPAQUE CYAN (and others)
	rtFragColor = vec4(0.0, 1.0, 1.0, 1.0);
	rtDiffuseMapSample = texture(uTex_dm, aTexCoord.xy);
	rtSpecularMapSample = texture(uTex_sm, aTexCoord.xy);
	rtDiffuseLightTotal = vec4(1.0, 0.0, 1.0, 1.0);
	rtSpecularLightTotal = vec4(1.0, 1.0, 0.0, 1.0);

	// Point of the viewer
	vec4 perspectivePosition = vec4(0,0,0,1);

	// Make texture color
	//vec4 originalTex = texture(uTex_dm, passTexcoord.xy); 

	/*// Phong shading for Light 1
	specularProduct = min(max((uLightCt - 0),0),1) * specularMagnifier * CalculateSpecularCoefficient(mVNormal,passViewPosition, perspectivePosition,  CalculateLightVector(passViewPosition,uLightPos[0]));
	lambertianProduct = min(max((uLightCt - 0),0),1) * diffuseMagnifier * CalculateLambertianProduct(mVNormal, CalculateLightVector(passViewPosition,uLightPos[0]));
	vec4 mixedColors = uLightCol[0] * lambertianProduct + specularProduct + (min(max((uLightCt - 0),0),1) * ambiance);

	// Phong shading for Light 2
	specularProduct = min(max((uLightCt - 1),0),1) * specularMagnifier * CalculateSpecularCoefficient(mVNormal,passViewPosition, perspectivePosition,  CalculateLightVector(passViewPosition,uLightPos[1]));
	lambertianProduct = min(max((uLightCt - 1),0),1) * diffuseMagnifier * CalculateLambertianProduct(mVNormal, CalculateLightVector(passViewPosition,uLightPos[1]));
	mixedColors += uLightCol[1] * lambertianProduct + specularProduct + (min(max((uLightCt - 1),0),1) * ambiance);

	// Phong shading for Light 3
	specularProduct = min(max((uLightCt - 2),0),1) * specularMagnifier * CalculateSpecularCoefficient(mVNormal,passViewPosition, perspectivePosition,  CalculateLightVector(passViewPosition,uLightPos[2]));
	lambertianProduct = min(max((uLightCt - 2),0),1) * diffuseMagnifier * CalculateLambertianProduct(mVNormal, CalculateLightVector(passViewPosition,uLightPos[2]));
	mixedColors += uLightCol[2] * lambertianProduct + specularProduct + (min(max((uLightCt - 2),0),1) * ambiance);

	// Phong shading for Light 4
	specularProduct = min(max((uLightCt - 3),0),1) * specularMagnifier * CalculateSpecularCoefficient(mVNormal,passViewPosition, perspectivePosition,  CalculateLightVector(passViewPosition,uLightPos[3]));
	lambertianProduct = min(max((uLightCt - 3),0),1) * diffuseMagnifier * CalculateLambertianProduct(mVNormal, CalculateLightVector(passViewPosition,uLightPos[3]));
	mixedColors += uLightCol[3] * lambertianProduct + specularProduct + (min(max((uLightCt - 3),0),1) * ambiance);
	
	// Return final color
	rtFragColor = originalTex * mixedColors;*/
}
