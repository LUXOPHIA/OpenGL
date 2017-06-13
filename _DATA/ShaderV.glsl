#version 150

////////////////////////////////////////////////////////////////////////////////【共通定数】

layout(std140) uniform TViewerDat
{
  layout(row_major) mat4 Scal;
}
_Viewer;

layout(std140) uniform TCameraDat
{
  layout(row_major) mat4 Proj;
  layout(row_major) mat4 Move;
}
_Camera;

layout(std140) uniform TShaperDat
{
  layout(row_major) mat4 Move;
}
_Shaper;

////////////////////////////////////////////////////////////////////////////////【入出力】

in vec4 _Vertex_Pos;
in vec4 _Vertex_Nor;
in vec2 _Vertex_Tex;

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
  _Result.Pos =                     _Shaper.Move     * _Vertex_Pos;
  _Result.Nor = transpose( inverse( _Shaper.Move ) ) * _Vertex_Nor;
  _Result.Tex =                                        _Vertex_Tex;

  gl_Position = _Viewer.Scal * _Camera.Proj * inverse( _Camera.Move ) * _Result.Pos;
}

//##############################################################################
