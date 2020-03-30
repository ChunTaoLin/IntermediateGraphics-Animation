#version 410 core
//
//////the out varying float value that will be passed to the fragment shader to determine color
//in float noiseValue;

in gl_PerVertex
{
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
} gl_in[gl_MaxPatchVertices];

out gl_PerVertex
{
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
} gl_out[];

layout (vertices = 3) out;
//layout (location = 8) in vec4 stuff;

void main(void)
{
    gl_TessLevelInner[0] = 7.0;
    gl_TessLevelOuter[0] = 2.0;
    gl_TessLevelOuter[1] = 3.0;
    gl_TessLevelOuter[2] = 7.0;
    gl_TessLevelInner[1] = 5.0;
    gl_TessLevelOuter[3] = 7.0;
//in case of quad, you have to specify both gl_TessLevelInner[1] and //gl_TessLevelOuter[3]
  //  } 
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;
}

//
//// define the number of CPs in the output patch
//layout (vertices = 3) out;
//
//layout (location = 0) in vec4 worldPos;
//
//// attributes of the input CPs
//in vec4 WorldPos_CS_in[];
//in vec2 TexCoord_CS_in[];
//in vec4 Normal_CS_in[];
//
//// attributes of the output CPs
//out vec4 WorldPos_ES_in[];
//out vec2 TexCoord_ES_in[];
//out vec4 Normal_ES_in[];
//
//float GetTessLevel(float Distance0, float Distance1)
//{
//    float AvgDistance = (Distance0 + Distance1) / 2.0;
//
//    if (AvgDistance <= 2.0) {
//        return 10.0;
//    }
//    else if (AvgDistance <= 5.0) {
//        return 7.0;
//    }
//    else {
//        return 3.0;
//    }
//}
//void main()
//{
//  // Set the control points of the output patch
//    TexCoord_ES_in[gl_InvocationID] = TexCoord_CS_in[gl_InvocationID];
//    Normal_ES_in[gl_InvocationID] = Normal_CS_in[gl_InvocationID];
//    WorldPos_ES_in[gl_InvocationID] = WorldPos_CS_in[gl_InvocationID];
//
//       // Calculate the distance from the camera to the three control points
//    float EyeToVertexDistance0 = distance(worldPos, WorldPos_ES_in[0]);
//    float EyeToVertexDistance1 = distance(worldPos, WorldPos_ES_in[1]);
//    float EyeToVertexDistance2 = distance(worldPos, WorldPos_ES_in[2]);
//
//    // Calculate the tessellation levels
//    gl_TessLevelOuter[0] = GetTessLevel(EyeToVertexDistance1, EyeToVertexDistance2);
//    gl_TessLevelOuter[1] = GetTessLevel(EyeToVertexDistance2, EyeToVertexDistance0);
//    gl_TessLevelOuter[2] = GetTessLevel(EyeToVertexDistance0, EyeToVertexDistance1);
//    gl_TessLevelInner[0] = gl_TessLevelOuter[2];
//};