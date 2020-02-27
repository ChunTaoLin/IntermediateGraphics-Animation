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
	
	drawPhongVolume_fs4x.glsl
	Draw Phong lighting components to render targets (diffuse & specular).
*/

#version 410

#define MAX_LIGHTS 1024

// ****TO-DO: 
//	0) copy deferred Phong shader
//	1) declare g-buffer textures as uniform samplers
//	2) declare lighting data as uniform block
//	3) calculate lighting components (diffuse and specular) for the current 
//		light only, output results (they will be blended with previous lights)
//			-> use reverse perspective divide for position using scene depth
//			-> use expanded normal once sampled from normal g-buffer
//			-> do not use texture coordinate g-buffer

in vec4 vViewPosition;
in  vec4 vViewNormal;
in vec4 vTexcoord;
in vec4 vBiasedClipCoord;

flat in int vInstanceID;

// Texture Values
uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;
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
uniform vec4 uColor[4];

vec4 mixedColors = vec4(0);

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
float diffuseTotal;
float specularTotal;

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


// simple point light struct
struct a3_DemoPointLight
{
	vec4 worldPos;					// position in world space
	vec4 viewPos;						// position in viewer space
	vec4 color;						// RGB color with padding
	float radius;						// radius (distance of effect from center)
	float radiusInvSq;					// radius inverse squared (attenuation factor)
	float pad[2];						// padding
};

// Uniform block 
uniform ubPointLight 
{
 a3_DemoPointLight lightData[4];
}allLightData;


void main()
{
	float depth = texture(uImage00, vTexcoord.xy).x;
	vec4 vNormal = texture(uImage02,vTexcoord.xy);

	//View Pos G buffer
	rtViewPos = vec4(vTexcoord.xy, depth,1.0);
	rtViewPos = uPB_inv * rtViewPos;
	rtViewPos /= rtViewPos.a;

	//Normal G buffer NEEDS TWEAKING
	rtViewNormal = texture(uImage02,vTexcoord.xy);
	rtViewNormal = uPB_inv * rtViewNormal;
	rtViewNormal = normalize(rtViewNormal * 0.5 + 0.5);

	// Point of the viewer
	vec4 perspectivePosition = vec4(0,0,0,1);

	vec4 spec;

	// Phong shading for Lights
	specularProduct = min(max((uLightCt - vInstanceID),0),1) * specularMagnifier * CalculateSpecularCoefficient(rtViewNormal,rtViewPos, perspectivePosition,  CalculateLightVector(rtViewPos,allLightData.lightData[vInstanceID].worldPos));
	lambertianProduct = min(max((uLightCt - vInstanceID),0),1) * diffuseMagnifier * CalculateLambertianProduct(rtViewNormal, CalculateLightVector(rtViewPos,allLightData.lightData[vInstanceID].worldPos));
	mixedColors = allLightData.lightData[vInstanceID].color * lambertianProduct + specularProduct + (min(max((uLightCt - vInstanceID),0),1) * ambiance);
	diffuseTotal = lambertianProduct;
	specularTotal = specularProduct;
	spec = specularProduct * allLightData.lightData[vInstanceID].color;

	rtSpecularLightTotal = specularTotal * spec * specularMagnifier +  allLightData.lightData[vInstanceID].color;
	rtDiffuseLightTotal = diffuseMagnifier + mixedColors + allLightData.lightData[vInstanceID].color;
}