Shader "Custom/ShowRect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Rect ("min max rect", Vector) = (0,0,1,1)
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		half4 _Rect;
			
		half4 frag(v2f_img i) : COLOR{
#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0) 
				i.uv.y = 1-i.uv.y;
#endif
			
			half2 uv = (i.uv-_Rect.xy)/(_Rect.zw-_Rect.xy);
			half2 t = half2(0,0)<uv&&uv<half2(1,1);
			return t.x*t.y;
		}
	ENDCG
	
	SubShader {
		ZTest Always ZWrite Off
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