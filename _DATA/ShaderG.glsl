#version 430

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%【ルーチン】

vec4 CrossProduct( vec4 A_, vec4 B_ )
{
  vec4 Result;

  Result.x = A_.y * B_.z - A_.z * B_.y;
  Result.y = A_.z * B_.x - A_.x * B_.z;
  Result.z = A_.x * B_.y - A_.y * B_.x;
  Result.w = 0;

  return Result;
}

vec4 FaceNorm( vec4 P1_, vec4 P2_, vec4 P3_ )
{
  return CrossProduct( P2_ - P1_, P3_ - P1_ );
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

//############################################################################## ■

layout( triangles ) in;

in TSenderVG
{
  vec4 Pos;
  vec4 Nor;
  vec2 Tex;
}
_Sender[ 3 ];

//------------------------------------------------------------------------------

layout( triangle_strip, max_vertices = 21 ) out;

out TSenderGF
{
  vec4 Pos;
  vec4 Nor;
  vec2 Tex;
}
_Result;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%【型】

struct TPoin
{
  vec4 Pos;
  vec4 Nor;
  vec2 Tex;
};

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%【ルーチン】

void AddPoin( TPoin Poin_ )
{
  _Result.Pos = Poin_.Pos;
  _Result.Nor = Poin_.Nor;
  _Result.Tex = Poin_.Tex;

  gl_Position = _ViewerScal * _CameraProj * inverse( _CameraPose ) * _Result.Pos;

  EmitVertex();
}

//------------------------------------------------------------------------------

void AddFace( TPoin P1_, TPoin P2_, TPoin P3_ )
{
  AddPoin( P1_ );
  AddPoin( P2_ );
  AddPoin( P3_ );

  EndPrimitive();
}

void AddFace( TPoin P1_, TPoin P2_, TPoin P3_, TPoin P4_ )
{
  AddFace( P1_, P2_, P3_ );
  AddFace( P3_, P4_, P1_ );
}

//------------------------------------------------------------------------------

void AddFaceFlat( TPoin P1_, TPoin P2_, TPoin P3_ )
{
  vec4 N = FaceNorm( P1_.Pos, P2_.Pos, P3_.Pos );

  P1_.Nor = N;
  P2_.Nor = N;
  P3_.Nor = N;

  AddFace( P1_, P2_, P3_ );
}

void AddFaceFlat( TPoin P1_, TPoin P2_, TPoin P3_, TPoin P4_ )
{
  vec4 N = FaceNorm( P1_.Pos, P2_.Pos, P3_.Pos );

  P1_.Nor = N;
  P2_.Nor = N;
  P3_.Nor = N;
  P4_.Nor = N;

  AddFace( P1_, P2_, P3_, P4_ );
}

//------------------------------------------------------------------------------

TPoin Corner( TPoin P1_, TPoin P2_, TPoin P3_ )
{
  TPoin Result;

  const float W1 = 0.1;
  const float W2 = 0.8;
  const float W3 = 0.1;

  Result.Pos = W1 * P1_.Pos + W2 * P2_.Pos + W3 * P3_.Pos;
  Result.Nor = W1 * P1_.Nor + W2 * P2_.Nor + W3 * P3_.Nor;
  Result.Tex = W1 * P1_.Tex + W2 * P2_.Tex + W3 * P3_.Tex;

  Result.Pos += 0.001 * normalize( Result.Nor );

  return Result;
}

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

void main()
{
  TPoin P1 = TPoin( _Sender[ 0 ].Pos, _Sender[ 0 ].Nor, _Sender[ 0 ].Tex );
  TPoin P2 = TPoin( _Sender[ 1 ].Pos, _Sender[ 1 ].Nor, _Sender[ 1 ].Tex );
  TPoin P3 = TPoin( _Sender[ 2 ].Pos, _Sender[ 2 ].Nor, _Sender[ 2 ].Tex );

  //  P3
  //  │＼
  //  │  ＼
  //  │C3  ＼
  //  ││＼  ＼
  //  ││  ＼  ＼
  //  │C1──C2  ＼
  //  P1──────P2

  TPoin C1 = Corner( P3, P1, P2 );
  TPoin C2 = Corner( P1, P2, P3 );
  TPoin C3 = Corner( P2, P3, P1 );

  AddFace( C1, C2, C3 );

  AddFaceFlat( P1, P2, C2, C1 );
  AddFaceFlat( P2, P3, C3, C2 );
  AddFaceFlat( P3, P1, C1, C3 );
}

//############################################################################## ■
