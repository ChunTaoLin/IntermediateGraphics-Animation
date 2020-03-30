#version 410 core

in gl_PerVertex
{
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
} gl_in[gl_MaxPatchVertices];


out gl_PerVertex {
  vec4 gl_Position;
  float gl_PointSize;
  float gl_ClipDistance[];
};

vec2 interpolate2D(vec2 v0, vec2 v1, vec2 v2)
{
    return vec2(gl_TessCoord.x) * v0 + vec2(gl_TessCoord.y) * v1 + vec2(gl_TessCoord.z) * v2;
}

layout(triangles) in;
in vec2 aESTexCoord[];
out vec2 aGSTexCoord;
void main(void)
{
    aGSTexCoord = interpolate2D(aESTexCoord[0], aESTexCoord[1], aESTexCoord[2]);
    vec4 p1 = mix(gl_in[1].gl_Position,gl_in[0].gl_Position,gl_TessCoord.x);
    vec4 p2 = mix(gl_in[2].gl_Position,gl_in[3].gl_Position,gl_TessCoord.x);
     
    gl_Position = mix(p1, p2, gl_TessCoord.y);
}

////Testing purposes
// //gl_Position = vec4(mix(p1, p2, gl_TessCoord.y).x,mix(p1, p2, gl_TessCoord.y).x,mix(p1, p2, gl_TessCoord.y).x,mix(p1, p2, gl_TessCoord.y).w);
//
//layout(triangles, equal_spacing, ccw) in;
//
//uniform mat4 uMVP;
//uniform mat4 uP_inv;
//
//uniform sampler2D uTex_nm;
//uniform float gDispFactor;
//
//in vec4 WorldPos_ES_in[];
//in vec2 TexCoord_ES_in[];
//in vec4 Normal_ES_in[];
//
//out vec4 WorldPos_FS_in;
//out vec2 TexCoord_FS_in;
//out vec4 Normal_FS_in;
//vec2 interpolate2D(vec2 v0, vec2 v1, vec2 v2)
//{
//    return vec2(gl_TessCoord.x) * v0 + vec2(gl_TessCoord.y) * v1 + vec2(gl_TessCoord.z) * v2;
//}
//
//vec4 interpolate3D(vec4 v0, vec4 v1, vec4 v2)
//{
//     return vec4((gl_TessCoord.x) * v0 + vec4(gl_TessCoord.y) * v1 + vec4(gl_TessCoord.z) * v2);
//}
//void main()
//{
//    // Interpolate the attributes of the output vertex using the barycentric coordinates
//    TexCoord_FS_in = interpolate2D(TexCoord_ES_in[0].xy, TexCoord_ES_in[1].xy, TexCoord_ES_in[2].xy);
//    Normal_FS_in = interpolate3D(Normal_ES_in[0], Normal_ES_in[1], Normal_ES_in[2]);
//    Normal_FS_in = normalize(Normal_FS_in);
//    WorldPos_FS_in = interpolate3D(WorldPos_ES_in[0], WorldPos_ES_in[1], WorldPos_ES_in[2]);
//
//        // Displace the vertex along the normal
//    float Displacement = texture(uTex_nm, TexCoord_FS_in.xy).x;
//    WorldPos_FS_in += Normal_FS_in * Displacement * 1;
//    gl_Position = uMVP * vec4(WorldPos_FS_in);
//}