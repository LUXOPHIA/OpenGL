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

uniform sampler2D _Imager;

////////////////////////////////////////////////////////////////////////////////【入出力】

in TSendVF
{
  vec4 Pos;
  vec4 Nor;
  vec2 Tex;
}
_Sender;

//------------------------------------------------------------------------------

out vec4 _Frag_Col;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void main()
{
  _Frag_Col = ( 1 + normalize( _Sender.Nor ) ) / 2 * texture( _Imager, _Sender.Tex );
}

//##############################################################################
