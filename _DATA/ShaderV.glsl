#version 150

////////////////////////////////////////////////////////////////////////////////【共通定数】

layout(std140) uniform TCamera
{
  layout(row_major) mat4 Proj;
  layout(row_major) mat4 Move;
}
_Camera;

layout(std140) uniform TGeomet
{
  layout(row_major) mat4 Move;
}
_Geomet;

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
  _Result.Pos =                     _Geomet.Move     * _Vertex_Pos;
  _Result.Nor = transpose( inverse( _Geomet.Move ) ) * _Vertex_Nor;
  _Result.Tex =                                        _Vertex_Tex;

  gl_Position = _Camera.Proj * inverse( _Camera.Move ) * _Result.Pos;
}

//##############################################################################
