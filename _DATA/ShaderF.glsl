﻿#version 150

////////////////////////////////////////////////////////////////////////////////【定数】

const float Pi = 3.141592653589793;

const float Pi2 = Pi * 2.0;

const float P2i = Pi / 2.0;

////////////////////////////////////////////////////////////////////////////////【ルーチン】

vec2 VecToSky( vec4 Vector_ )
{
    vec2 Result;

    Result.x = ( Pi - atan( -Vector_.x, -Vector_.z ) ) / Pi2;
    Result.y =        acos(  Vector_.y             )   / Pi ;

    return Result;
}

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
  vec4 C = _Camera.Move * vec4( 0, 0, 0, 1 );
  vec4 V = normalize( _Sender.Pos - C );
  vec4 R = reflect( V, normalize( _Sender.Nor ) );

  _Frag_Col = texture( _Imager, VecToSky( R ) );
}

//##############################################################################
