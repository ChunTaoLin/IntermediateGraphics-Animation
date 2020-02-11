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
	
	drawPhong_multi_shadow_mrt_fs4x.glsl
	Draw Phong shading model for multiple lights with MRT output and 
		shadow mapping.
*/

#version 410

// ****TO-DO: 
//	0) copy existing Phong shader
//	1) receive shadow coordinate
//	2) perform perspective divide
//	3) declare shadow map texture
//	4) perform shadow test

in vec4 aShadowCoordOut;

// Texture Values
uniform sampler2D uTex_dm;
uniform sampler2D uTex_shadow;
layout (location = 8) in vec4 aTexCoord;

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

out vec4 rtFragColor;





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
	// Point of the viewer
	vec4 perspectivePosition = vec4(0,0,0,1);

	// Make texture color
	vec4 originalTex = texture(uTex_dm, aTexCoord.xy); 

	// Complete calculations for shadow map
	vec4 perspectiveDivide = aShadowCoordOut / aShadowCoordOut.w;
	float shadowSample = texture2D(uTex_shadow, perspectiveDivide.xy).r;
	bool fragIsShadowed = (perspectiveDivide.z > shadowSample);

	if (fragIsShadowed) 
	{
		diffuseMagnifier *= 0.2;
	}

	// Phong shading for Light 1
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
	rtFragColor = originalTex * mixedColors;
}

