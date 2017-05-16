#version 150

////////////////////////////////////////////////////////////////////////////////【定数】

layout(std140) uniform TCamera
{
  layout(row_major) mat4 Proj;
  layout(row_major) mat4 Move;
}
_Camera;

layout(std140) uniform TShape
{
  layout(row_major) mat4 Move;
}
_Shape;

////////////////////////////////////////////////////////////////////////////////【入出力】

in struct TVert
{
  vec4 Pos;
  vec4 Col;
}
_Vert;

out TSendVF
{
  vec4 Col;
}
_Result;

//------------------------------------------------------------------------------

void main()
{
  gl_Position = _Camera.Proj *inverse( _Camera.Move )
              * _Shape.Move
              * _Vert.Pos;
  _Result.Col = _Vert.Col;
}

//##############################################################################
