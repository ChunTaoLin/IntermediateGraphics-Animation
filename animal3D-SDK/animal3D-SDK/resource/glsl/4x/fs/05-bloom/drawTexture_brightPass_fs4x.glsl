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
	
	drawTexture_brightPass_fs4x.glsl
	Draw texture sample with brightening.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) implement brightness function (e.g. luminance)
//	2) use brightness to implement tone mapping or just filter out dark areas

//using the blue book as reference

// Texture Values
uniform sampler2D uImage00;

float bloom_thresh_min = .7;
float bloom_thresh_max = 1.2;
layout (location = 0) out vec4 rtFragColor;

in vec4 passTexcoord;

void main()
{
	//sample the data with the texture of the image
	vec3 data =  texture(uImage00,passTexcoord.xy).rgb;

	float Y = dot(data, vec3(0.2, 0.3, 0.4));
	
	//then do smoothstep for a gradual change in the brightness rather than a definitive cut
	data = data * 4.0 * smoothstep(bloom_thresh_min, bloom_thresh_max,Y);

	// Apply texture onto given pixel
	rtFragColor = vec4(data,1.0);
}
