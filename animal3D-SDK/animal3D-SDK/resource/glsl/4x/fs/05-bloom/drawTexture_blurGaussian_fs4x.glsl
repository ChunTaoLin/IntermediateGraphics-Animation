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
	
	drawTexture_blurGaussian_fs4x.glsl
	Draw texture with Gaussian blurring.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) declare uniforms for pixel size and sampling axis
//	2) implement Gaussian blur function using a 1D kernel (hint: Pascal's triangle)
//	3) sample texture using Gaussian blur function and output result

//Uniforms
uniform sampler2D uImage00;
uniform sampler2D uTex_dm;
uniform vec2 uSize;
uniform vec2 uAxis;
in vec4 passTexcoord;

layout (location = 0) out vec4 rtFragColor;

const float weights[] = float[](1,4,6,4,1);

/*
This shader is responsible for performing a Gaussian blur using a 1D kernel.
Implement a function to sample along the blur axis (direction of blurring), away from the center pixel, in single pixel increments; the pixel size is measured in texture units (pixelwidth = 1/samplingFBOwidth, pixelheight = 1/samplingFBOheight).
The kernel weights must add up to 1 and can be determined using some row in Pascal's triangle.
*/



void main()
{
	/*
	
A B C D E
F G H I J
L M N O P
Q R S T U
V W X Y Z
Result = (L * 1 + M * 4 + N * 6 + O * 4 + P * 1) / 16
	*/

	vec3 result = texture(uImage00, passTexcoord.xy).rgb * weights[2]; //current pixel contribution

	if (uAxis == vec2(1, 0) ) 
{
// code h

	result += texture(uImage00, uAxis * vec2(passTexcoord.x - uSize.x * 2, 0.0)).rgb * (weights[0]);
	result += texture(uImage00, uAxis * vec2(passTexcoord.x - uSize.x * 1, 0.0)).rgb * (weights[1]);
	result += texture(uImage00, uAxis * vec2(passTexcoord.x + uSize.x * 1, 0.0)).rgb * (weights[3]);
	result += texture(uImage00, uAxis * vec2(passTexcoord.x + uSize.x * 2, 0.0)).rgb * (weights[4]);

} else 
{
// code v

	result += texture(uImage00, uAxis * vec2(passTexcoord.y - uSize.y * 2, 0.0)).rgb * (weights[0]);
	result += texture(uImage00, uAxis * vec2(passTexcoord.y - uSize.y * 1, 0.0)).rgb * (weights[1]);
	result += texture(uImage00, uAxis * vec2(passTexcoord.y + uSize.y * 1, 0.0)).rgb * (weights[3]);
	result += texture(uImage00, uAxis * vec2(passTexcoord.y + uSize.y * 2, 0.0)).rgb * (weights[4]);
}
	result /= 16;

	vec4 tex = texture(uTex_dm,passTexcoord.xy);

	//output final
	result += tex.rgb;
    rtFragColor = vec4(result, 1.0);
}