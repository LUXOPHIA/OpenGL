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

in vec4 _VerterPos;
in vec4 _VerterNor;
in vec2 _VerterTex;

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
  _Result.Pos =                     _Shaper.Pose     * _VerterPos;
  _Result.Nor = transpose( inverse( _Shaper.Pose ) ) * _VerterNor;
  _Result.Tex =                                        _VerterTex;

  gl_Position = _ViewerScal * _Camera.Proj * inverse( _Camera.Pose ) * _Result.Pos;
}

//##############################################################################
