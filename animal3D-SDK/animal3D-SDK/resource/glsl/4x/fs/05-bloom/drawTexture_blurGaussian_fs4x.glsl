//Uniforms
uniform sampler2D uImage00;
uniform sampler2D uTex_dm;
uniform vec2 uSize;
uniform vec2 uAxis;
in vec4 passTexcoord;

// Texture values
layout (location = 0) out vec4 rtFragColor;

//highlighted row of pascals triangle
const float weights[] = float[](1,2,1);
/*
This shader is responsible for performing a Gaussian blur using a 1D kernel.
Implement a function to sample along the blur axis (direction of blurring), away from the center pixel, in single pixel increments; the pixel size is measured in texture units (pixelwidth = 1/samplingFBOwidth, pixelheight = 1/samplingFBOheight).
The kernel weights must add up to 1 and can be determined using some row in Pascal's triangle.
*/

void main()
{
//bonus? less texture
	//the center pixel
	vec3 result = texture(uImage00, passTexcoord.xy).rgb * weights[1]; //current pixel contribution
	//neighboring ones

	result += texture(uImage00, passTexcoord.xy + (uSize.xy * uAxis)).rgb * weights[0];
	result += texture(uImage00, passTexcoord.xy - (uSize.xy * uAxis)).rgb * weights[2];

	//division by 4 to make kernal value wieghts add to 1
	result /= 4;

	//output final
    rtFragColor = vec4(result, 1.0);
}
