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

uniform sampler2D uImage00;
uniform vec2 uSize;
uniform vec2 uAxis;
in vec4 passTexcoord;
layout (location = 0) out vec4 rtFragColor;

float bloom_thresh_min = 0.8;
float bloom_thresh_max = 1.2;

const float weights[] = float[](1,4,6,4,1);

/*
This shader is responsible for performing a Gaussian blur using a 1D kernel.
Implement a function to sample along the blur axis (direction of blurring), away from the center pixel, in single pixel increments; the pixel size is measured in texture units (pixelwidth = 1/samplingFBOwidth, pixelheight = 1/samplingFBOheight).
The kernel weights must add up to 1 and can be determined using some row in Pascal's triangle.
*/

void main()
{
	vec2 pixelSize = 1/16 * uAxis; 
	vec2 offset = textureSize(uImage00,0);
	float pixelWidth = 1/offset.x * uAxis.x;
	float pixelHeight = 1/offset.y* uAxis.y;

 vec3 result = texture(uImage00, passTexcoord.xy).rgb * weights[0]; // current fragment's contribution
        for(int i = 1; i < 5; i++)
        {
//            result += texture(uImage00, passTexcoord.xy + vec2(offset.x * i, 0.0)).rgb * weights[i];
//            result += texture(uImage00, passTexcoord.xy - vec2(offset.x * i, 0.0)).rgb * weights[i];
			 result += texture(uImage00, passTexcoord.xy + vec2(pixelWidth * i, 0.0)).rgb * weights[i];
            result += texture(uImage00, passTexcoord.xy - vec2(pixelHeight * i, 0.0)).rgb * weights[i];
			
            //result += texelFetchOffset(uImage00, passTexcoord.xy - vec2(offset.x * i, 0.0)).rgb * weights[i];
        }
  
    rtFragColor = vec4(result, 1.0);
}