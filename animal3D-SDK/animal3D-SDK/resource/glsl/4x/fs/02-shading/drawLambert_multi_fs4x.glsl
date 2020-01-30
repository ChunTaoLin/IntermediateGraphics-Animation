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
layout (location = 8) in vec4 aTexCoord;
in vec4 viewPosition;
layout (location = 2) in vec4 mVNormal;

out vec4 rtFragColor;

float specularMagnifier = 0.3;

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
	float lambertianProduct = CalculateLambertianProduct(mVNormal, CalculateLightVector(viewPosition,uLightPos[0]));//white spot
	float lambertianProduct2 = CalculateLambertianProduct(mVNormal, CalculateLightVector(viewPosition,uLightPos[1]));//purplewhite
	float lambertianProduct3 = CalculateLambertianProduct(mVNormal, CalculateLightVector(viewPosition,uLightPos[2]));//yellowspot
	float lambertianProduct4 = CalculateLambertianProduct(mVNormal, CalculateLightVector(viewPosition,uLightPos[3]));//bluespot

	float lambertianProductSum = lambertianProduct + lambertianProduct2 + lambertianProduct3 + lambertianProduct4;
//	lambertianProduct += CalculateLambertianProduct(mVNormal, CalculateLightVector(viewPosition,uLightPos[1]));
	//lambertianProduct += CalculateLambertianProduct(mVNormal, CalculateLightVector(viewPosition,uLightPos[2]));
	//lambertianProduct += CalculateLambertianProduct(mVNormal, CalculateLightVector(viewPosition,uLightPos[3]));

	vec4 originalTex = texture(uTex_dm, aTexCoord.xy); 

	vec4 color1 = mix(originalTex,uLightCol[0],0.1) * lambertianProduct;
	vec4 color2 = mix(originalTex,uLightCol[1],0.2) * lambertianProduct2;
	vec4 color3 = mix(originalTex,uLightCol[2],0.2) * lambertianProduct3;
	vec4 color4 = mix(originalTex,uLightCol[3],0.6) * lambertianProduct4;
	
	//originalTex = originalTex * CalculateSpecularCoefficient(uLightPos[0],viewPosition,lambertianProduct);
	//vec4 mixedColors = color1;//mix(color1, color3,.3);
	//mixedColors = mix(mixedColors, color2,.3);
	//mixedColors = mix(mixedColors, color4,.5);
	//result = mix(originalTex,uLightCol[0],.5);
//	//vec4 result = mix(uLightCol[0],originalTex,1);
//
//	vec4 color1 = uLightCol[0] * lambertianProduct;
//	vec4 color2 = uLightCol[1] * lambertianProduct2; 
//	vec4 color3 = uLightCol[2] * lambertianProduct3;
//	vec4 color4 = uLightCol[3] * lambertianProduct4;
//
//	color1 = mix(originalTex,color1,1.0);
	vec4 mixedColors = mix(originalTex, color1,.2);
	mixedColors = mix(mixedColors, color2,.4);
	mixedColors = mix(mixedColors, color3,.2);
	mixedColors = mix(mixedColors, color4,.3);

	rtFragColor = mixedColors * lambertianProductSum;//mixedColors * lambertianProductSum;
}
