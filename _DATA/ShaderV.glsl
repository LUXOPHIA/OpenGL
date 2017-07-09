#version 430

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

in vec4 _SenderPos;
in vec4 _SenderNor;
in vec2 _SenderTex;

//------------------------------------------------------------------------------

out TSenderVG
{
  vec4 Pos;
  vec4 Nor;
  vec2 Tex;
}
_Result;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

void main()
{
  _Result.Pos =                     _ShaperPose     * _SenderPos;
  _Result.Nor = transpose( inverse( _ShaperPose ) ) * _SenderNor;
  _Result.Tex =                                       _SenderTex;

  //gl_Position = _ViewerScal * _CameraProj * inverse( _CameraPose ) * _Result.Pos;
}

//############################################################################## ■
