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
	
	drawLambert_multi_fs4x.glsl
	Draw Lambert shading model for multiple lights.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Lambert shading model
//	Note: test all data and inbound values before using them!

uniform sampler2D uTex_dm;
uniform vec4 uLightPos[4];
uniform vec4 uLightCol[4];
uniform int uLightCt;

layout (location = 8) in vec4 aTexCoord;
in vec4 passViewPosition;
layout (location = 2) in vec4 mVNormal;

out vec4 rtFragColor;

float specularMagnifier = 0.3;

float lambertianProduct;
float lambertianProduct2;
float lambertianProduct3;
float lambertianProduct4;

vec4 CalculateLightVector(vec4 position, vec4 lightPos) 
{
	vec4 lightNorm = lightPos - position;
	return normalize(lightNorm);
}

float CalculateLambertianProduct(vec4 surfaceNormal, vec4 lightNormal) 
{
	return dot(surfaceNormal,lightNormal);
}

//float CalculateSpecularCoefficient(vec4 viewPos, vec4 surfacePoint, vec4 lambertianProd)
//{
//	vec4 specular = viewPos - surfacePoint;

//	specular = specular;

//	float endCoefficient = pow(dot(specular, lambertianProd),specularMagnifier);
//	return endCoefficient;
//}

void main()
{

	if(uLightCt >= 1)
	{
		lambertianProduct = CalculateLambertianProduct(mVNormal, CalculateLightVector(passViewPosition,uLightPos[0]));//white spot
	}
	else
		lambertianProduct = 0;

	if(uLightCt >= 2)
	{
		lambertianProduct2 = CalculateLambertianProduct(mVNormal, CalculateLightVector(passViewPosition,uLightPos[1]));//purplewhite
	}
	else
		lambertianProduct2 = 0;

	if(uLightCt >= 3)
	{
		lambertianProduct3 = CalculateLambertianProduct(mVNormal, CalculateLightVector(passViewPosition,uLightPos[2]));//yellowspot
	}
	else 
		lambertianProduct3 = 0;

	if(uLightCt == 4)
	{
		lambertianProduct4 = CalculateLambertianProduct(mVNormal, CalculateLightVector(passViewPosition,uLightPos[3]));//bluespot
	}
	else
		lambertianProduct4 = 0;

	vec4 originalTex = texture(uTex_dm, aTexCoord.xy); 

	vec4 color1 = uLightCol[0] * lambertianProduct;
	vec4 color2 = uLightCol[1]  * lambertianProduct2;
	vec4 color3 = uLightCol[2]  * lambertianProduct3;
	vec4 color4 = uLightCol[3]  * lambertianProduct4;

	vec4 mixedColors = color1 + color2 +color3+ color4;

	rtFragColor = mixedColors * originalTex;
}
