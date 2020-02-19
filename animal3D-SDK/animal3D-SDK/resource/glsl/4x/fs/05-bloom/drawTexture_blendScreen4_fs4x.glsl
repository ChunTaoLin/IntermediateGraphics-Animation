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
	
	drawTexture_blendScreen4_fs4x.glsl
	Draw blended sample from multiple textures using screen function.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) declare additional texture uniforms
//	2) implement screen function with 4 inputs
//	3) use screen function to sample input textures

uniform sampler2D uImage00;
uniform sampler2D uImage01;
uniform sampler2D uImage02;
uniform sampler2D uImage03;

layout (location = 0) out vec4 rtFragColor;
in vec4 passTexcoord;

vec4 screen(sampler2D image01, sampler2D image02, sampler2D image03, sampler2D image04) 
{
	vec4 color1 = texture(image01, passTexcoord.xy);
	vec4 color2 = texture(image02, passTexcoord.xy);
	vec4 color3 = texture(image03, passTexcoord.xy);
	vec4 color4 = texture(image04, passTexcoord.xy);

	return 1 - (1 - color1) * (1 - color2) * (1 - color3) * (1 - color4);
}


void main()
{
	rtFragColor = screen(uImage00,uImage01,uImage02,uImage03);
}