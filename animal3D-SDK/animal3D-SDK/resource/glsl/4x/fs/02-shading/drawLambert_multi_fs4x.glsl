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
in vec4 mVNormal;

out vec4 rtFragColor;

float specularMagnifier = 0.3;

vec4 CalculateLightVector(vec4 position, vec4 lightPos) 
{
	vec4 lightNorm = normalize(lightPos) - normalize(position);
	return normalize(lightNorm);
}

vec4 CalculateLambertianProduct(vec4 surfaceNormal, vec4 lightNormal) 
{
	return max(2 * dot(surfaceNormal,lightNormal) * surfaceNormal - lightNormal,0.0);
}

float CalculateDiffuse(vec4 surfaceNormal, vec4 lightNormal)
{
	return max(dot(surfaceNormal,lightNormal),0.1);
}

float CalculateSpecularCoefficient(vec4 viewPos, vec4 surfacePoint, vec4 lambertianProd)
{
	vec4 specular = viewPos - surfacePoint;

	specular = normalize(specular);

	float endCoefficient = pow(dot(specular, lambertianProd),specularMagnifier);
	return endCoefficient;
}

void main()
{
	vec4 lambertianProduct = normalize(CalculateLambertianProduct(mVNormal, CalculateLightVector(viewPosition,uLightPos[0])));
//	lambertianProduct += normalize(CalculateLambertianProduct(mVNormal, CalculateLightVector(viewPosition,uLightPos[1])));
//	lambertianProduct += normalize(CalculateLambertianProduct(mVNormal, CalculateLightVector(viewPosition,uLightPos[2])));
//	lambertianProduct += normalize(CalculateLambertianProduct(mVNormal, CalculateLightVector(viewPosition,uLightPos[3])));
//
	vec4 originalTex = texture(uTex_dm, aTexCoord.xy); 
//	originalTex = mix(originalTex,uLightCol[0],.1);
//	originalTex = mix(originalTex,uLightCol[1],.1);
//	originalTex = mix(originalTex,uLightCol[2],.1);
//	originalTex = mix(originalTex,uLightCol[3],.1);
	//originalTex = originalTex * CalculateSpecularCoefficient(uLightPos[0],viewPosition,lambertianProduct);

	//result = mix(originalTex,uLightCol[0],.5);
	//vec4 result = mix(uLightCol[0],originalTex,1);
	rtFragColor = originalTex * CalculateSpecularCoefficient(uLightPos[0],viewPosition,lambertianProduct);//originalTex;//color1;//mix(color1,lambertianProduct,.5);//lambertianProduct;
}
