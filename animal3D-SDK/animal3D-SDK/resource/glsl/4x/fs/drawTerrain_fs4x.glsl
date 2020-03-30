#version 410

// Constants
const float SHADE_OF_GREEN = 0.25;

// Input noise value
in float aFSNoiseVal;

out vec4 rtFragColor;

void main()
{	
	// Amplify shade of green with noise value
	rtFragColor = vec4(0.0,SHADE_OF_GREEN,0.0,1.0) * aFSNoiseVal;
}
