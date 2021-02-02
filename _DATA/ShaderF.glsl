#version 430

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%【定数】

const float Pi  = 3.141592653589793;
const float Pi2 = Pi * 2.0;
const float P2i = Pi / 2.0;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%【ルーチン】

vec2 VecToSky( vec4 Vector_ )
{
    vec2 Result;

    Result.x = ( Pi - atan( -Vector_.x, -Vector_.z ) ) / Pi2;
    Result.y =        acos(  Vector_.y             )   / Pi ;

    return Result;
}

//------------------------------------------------------------------------------

vec3 ToneMap( in vec3 Color, in float White )
{
  return clamp( Color * ( 1 + Color / White ) / ( 1 + Color ), 0, 1 );
}

//------------------------------------------------------------------------------

vec3 GammaCorrect( in vec3 Color, in float Gamma )
{
  vec3 Result;

  float G = 1 / Gamma;

  Result.r = pow( Color.r, G );
  Result.g = pow( Color.g, G );
  Result.b = pow( Color.b, G );

  return Result;
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%【共通定数】

layout( std140 ) uniform TViewerScal
{
  layout( row_major ) mat4 _ViewerScal;
};

layout( std140 ) uniform TCameraProj
{
  layout( row_major ) mat4 _CameraProj;
};

layout( std140 ) uniform TCameraPose
{
  layout( row_major ) mat4 _CameraPose;
};

layout( std140 ) uniform TShaperPose
{
  layout( row_major ) mat4 _ShaperPose;
};

//------------------------------------------------------------------------------

uniform sampler2D _Textur;

//############################################################################## ■

in TSenderGF
{
  vec4 Pos;
  vec4 Nor;
  vec2 Tex;
}
_Sender;

//------------------------------------------------------------------------------

out vec4 _ResultCol;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

void main()
{
  vec4 C = _CameraPose[ 3 ];
  vec4 V = normalize( _Sender.Pos - C );
  vec4 R = reflect( V, normalize( _Sender.Nor ) );

  vec3 C0 = texture( _Textur, VecToSky( R ) ).rgb;
  vec3 C1 = ToneMap( C0, 1 );
  vec3 C2 = GammaCorrect( C1, 2.2 );

  _ResultCol = vec4( C2, 1 );
}

//############################################################################## ■
