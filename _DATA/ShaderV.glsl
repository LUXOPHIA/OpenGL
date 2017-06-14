#version 150

////////////////////////////////////////////////////////////////////////////////【共通定数】

layout(std140) uniform TViewerScal
{
  layout(row_major) mat4 _ViewerScal;
};

layout(std140) uniform TCameraProj
{
  layout(row_major) mat4 _CameraProj;
};

layout(std140) uniform TCameraPose
{
  layout(row_major) mat4 _CameraPose;
};

layout(std140) uniform TShaperPose
{
  layout(row_major) mat4 _ShaperPose;
};

////////////////////////////////////////////////////////////////////////////////【入出力】

in vec4 _VertexPos;
in vec4 _VertexNor;
in vec2 _VertexTex;

//------------------------------------------------------------------------------

out TSendVF
{
  vec4 Pos;
  vec4 Nor;
  vec2 Tex;
}
_Result;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void main()
{
  _Result.Pos =                     _ShaperPose     * _VertexPos;
  _Result.Nor = transpose( inverse( _ShaperPose ) ) * _VertexNor;
  _Result.Tex =                                       _VertexTex;

  gl_Position = _ViewerScal * _CameraProj * inverse( _CameraPose ) * _Result.Pos;
}

//##############################################################################
