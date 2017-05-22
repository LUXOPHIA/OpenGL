#version 150

////////////////////////////////////////////////////////////////////////////////【定数】

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

//------------------------------------------------------------------------------

out TSendVF
{
  vec4 Nor;
}
_Result;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void main()
{
  gl_Position = _Camera.Proj * inverse( _Camera.Move )
                                      * _Geomet.Move * _Vertex_Pos;

  _Result.Nor = transpose( inverse( _Geomet.Move ) ) * _Vertex_Nor;
}

//##############################################################################
