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
	
	drawTexture_outline_fs4x.glsl
	Draw texture sample with outlines.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) implement outline algorithm - see render code for uniform hints
uniform sampler2D uTex_dm;
uniform sampler2D uImage1;

layout (location = 8) in vec4 aTexCoord;

mat3 sobelX = mat3(
1.0,2.0,1.0,
0.0,0.0,0.0,
-1.0,-2.0,-1.0

);

mat3 sobelY = mat3(
1.0,0.0,-1.0,
2.0,0.0,-2.0,
1.0,0.0,-1.0

);

vec3 diff;
vec3 diff2;
out vec4 rtFragColor;

void main()
{
	diff = texture(uTex_dm,aTexCoord.xy).rgb;
	mat3 I;
	
	//place gradient matrix over each pixel of the image to determine the difference.
	for (int i  = 0; i < 3; i++)
	{
		for(int j = 0; j < 3; j++)
		{
			vec3 Sample = texelFetch(uTex_dm,ivec2(gl_FragCoord)+ ivec2(i -1,j-1),0).rgb;
			I[i][j] = length(Sample);
		}
	}

	float gradientX = dot(sobelX[0],I[0]) + dot(sobelX[1],I[1]) + dot(sobelX[2],I[2]);
	float gradientY = dot(sobelY[0],I[0]) + dot(sobelY[1],I[1]) + dot(sobelY[2],I[2]);

	float gradient = sqrt(pow(gradientX,2.0)+pow(gradientY,2.0));

	gradient = smoothstep(0.4,0.6,gradient);

	// Apply texture onto given pixel
	rtFragColor = vec4(diff - gradient,1.0);

	diff2 = texture(uImage1,aTexCoord.xy).rgb;

	//place gradient matrix over each pixel of the image to determine the difference.
	for (int i  = 0; i < 3; i++)
	{
		for(int j = 0; j < 3; j++)
		{
			vec3 Sample = texelFetch(uImage1,ivec2(gl_FragCoord)+ ivec2(i -1,j-1),0).rgb;
			I[i][j] = length(Sample);
		}
	}

	float gradientX2 = dot(sobelX[0],I[0]) + dot(sobelX[1],I[1]) + dot(sobelX[2],I[2]);
	float gradientY2 = dot(sobelY[0],I[0]) + dot(sobelY[1],I[1]) + dot(sobelY[2],I[2]);

	float gradient2 = sqrt(pow(gradientX2,2.0)+pow(gradientY2,2.0));
		rtFragColor = rtFragColor + vec4(diff2 - gradient2,1.0);
}