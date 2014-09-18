Shader "Custom/QuadWarp" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BL ("bottom left", Vector) = (0,0,0,0)
		_BR ("bottom right", Vector) = (1,0,0,0)
		_UL ("upper left", Vector) = (0,1,0,0)
		_UR ("upper right", Vector) = (1,1,0,0)
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half2 _BL,_BR,_UL,_UR;
		half4 _MainTex_TexelSize;
			
		half4 frag(v2f_img i) : COLOR{
#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0) 
				i.uv.y = 1-i.uv.y;
#endif
			half2 uv = i.uv;
			
			half2 deltaUV = 0;
			
			return tex2D(_MainTex, uv);
		}
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }
 
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	} 
}