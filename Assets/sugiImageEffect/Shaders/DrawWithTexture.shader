Shader "Custom/DrawWithTexture" {
	Properties {
		_Color ("color", Color) = (1,0,0,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_DrawTex ("draw texture", 2D) = "black"{}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex,_DrawTex;
		half4 _Color;
		
		half4 _MainTex_TexelSize;
			
		half4 frag(v2f_img i) : COLOR{
#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0) 
				i.uv.y = 1-i.uv.y;
#endif
			
			half4 b = tex2D(_MainTex, i.uv);
			b = lerp(b, half4(1,1,1,1), b.g < 0.85? 0.01:0.1);
				
			half d = tex2D(_DrawTex, i.uv);
			return lerp(b,_Color,d);
			
		}
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }  
		ColorMask RGB
 
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	} 
}