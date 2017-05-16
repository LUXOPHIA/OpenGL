﻿#version 150

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

in TSendVF
{
  vec4 Col;
}
_Sender;

out vec4 _FragColor;

//------------------------------------------------------------------------------

void main()
{
  _FragColor = _Sender.Col;
}

//##############################################################################
