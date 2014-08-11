Shader "Custom/DepthNormals" {

	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	
CGINCLUDE
	#include "UnityCG.cginc"
	sampler2D _MainTex,_CameraDepthNormalsTexture;
	half4 _MainTex_TexelSize;
	
	half4 frag (v2f_img i) : COLOR{
		
		half4 c = tex2D(_CameraDepthNormalsTexture, i.uv);
		
		float3 normals;
		float depth;
		DecodeDepthNormal(c, depth, normals);
		
		return half4(normals, depth);
	}
	
ENDCG

SubShader {
	ZTest Off
	
	Pass{
	CGPROGRAM
	#pragma vertex vert_img
	#pragma fragment frag
	ENDCG
	}
}
}