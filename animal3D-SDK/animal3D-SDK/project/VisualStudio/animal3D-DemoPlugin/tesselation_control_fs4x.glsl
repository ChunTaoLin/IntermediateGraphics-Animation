
//the out varying float value that will be passed to the fragment shader to determine color
in float noiseValue;
in vec4 tessPos;

struct
{
    vec4 gl_Position;
    float gl_PointSize;
    float gl_ClipDistance[ 6 ];
} gl_in[ ];


//struct
//{
//vec4 gl_Position;
//float gl_PointSize;
//float gl_ClipDistance[ 6 ];
//} gl_out[ ];
//
uniform mat4 uMVP;	// (1)

void main()
{
    tessPos.a -= 0.5;
}