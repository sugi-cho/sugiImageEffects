Shader "Custom/SimplePressure" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_P ("katamuki ryoku", Float) = 1
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half _P;
		half4 _MainTex_TexelSize;
			
		half4 frag(v2f_img i) : COLOR{
			half p = tex2D(_MainTex, i.uv).r;
			half2 dd = half2(ddx(p), ddy(p));
			return tex2D(_MainTex, i.uv - dd*_P*_MainTex_TexelSize.xy)*0.99;
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
			#pragma glsl
			ENDCG
		}
	} 
}