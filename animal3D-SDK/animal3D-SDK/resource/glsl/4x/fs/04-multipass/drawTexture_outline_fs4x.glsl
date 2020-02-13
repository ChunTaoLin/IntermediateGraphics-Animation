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
//Two uniform textures I will need, uTex_dm for the entire and sm for use in the outlining
uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;

layout (location = 8) in vec4 aTexCoord;

///Sobel Matrices
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
mat3 I;

out vec4 rtFragColor;

//how thick do you want it?
int lineThickness = 100;

mat3 CalculateSobel(mat3 I, sampler2D image)
{
	//place gradient matrix over each pixel of the image to determine the difference.
	for (int i  = 0; i < 3; i++)
	{
		for(int j = 0; j < 3; j++)
		{
			vec3 Sample = texelFetch(image,ivec2(gl_FragCoord)+ ivec2(i - 1,j- 1),0).rgb;
			I[i][j] = length(Sample);
		}
	}
	return I;
}


float CalculateGradient(float gradientX, float gradientY, float gradient)
{
	//Calculate the gradient for each x and y based on the dot product of each element of the sobel matrice with 
	gradientX = dot(sobelX[0],I[0]) + dot(sobelX[1],I[1]) + dot(sobelX[2],I[2]);
	gradientY = dot(sobelY[0],I[0]) + dot(sobelY[1],I[1]) + dot(sobelY[2],I[2]);

	gradient = sqrt(pow(gradientX,2.0) + pow(gradientY,2.0));
	return gradient;
}

void main()
{
	//Diffuse Map
	diff = texture(uTex_dm,aTexCoord.xy).rgb;
	
	//Sobel Algorithm
	I = CalculateSobel(I,uTex_sm);

	float gradientX;
	float gradientY;
	float gradient;

	//Gradient Calc
	gradient =	CalculateGradient(gradientX,gradientY,gradient);

	//Output result taking the diffuse map texture - the gradient to get the render of the scene with lines with varying thickness
	rtFragColor = vec4(diff - gradient * lineThickness,1.0);
}