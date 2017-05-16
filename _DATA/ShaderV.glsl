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

in vec4 _VertPos;
in vec4 _VertCol;

//------------------------------------------------------------------------------

out TSendVF
{
  vec4 Col;
}
_Result;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void main()
{
  gl_Position = _Camera.Proj *inverse( _Camera.Move )
              * _Shape.Move
              * _VertPos;
  _Result.Col = _VertCol;
}

//##############################################################################
