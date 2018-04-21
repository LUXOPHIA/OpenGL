#version 150

////////////////////////////////////////////////////////////////////////////////【共通定数】

layout(std140) uniform TViewerScal
{
  layout(row_major) mat4 _ViewerScal;
};

layout(std140) uniform TCameraData
{
  layout(row_major) mat4 Proj;
  layout(row_major) mat4 Pose;
}
_Camera;

layout(std140) uniform TShaperData
{
  layout(row_major) mat4 Pose;
}
_Shaper;

////////////////////////////////////////////////////////////////////////////////【入出力】

in vec4 _VerBufPos;
in vec4 _VerBufNor;
in vec2 _VerBufTex;

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
  _Result.Pos =                     _Shaper.Pose     * _VerBufPos;
  _Result.Nor = transpose( inverse( _Shaper.Pose ) ) * _VerBufNor;
  _Result.Tex =                                        _VerBufTex;

  gl_Position = _ViewerScal * _Camera.Proj * inverse( _Camera.Pose ) * _Result.Pos;
}

//##############################################################################
