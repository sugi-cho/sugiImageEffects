Shader "Custom/NegaMixier" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NegaTex ("mix tex", 2D) = "black" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex,_NegaTex;
		half4 _MainTex_TexelSize;
			
		half4 frag(v2f_img i) : COLOR{
			return tex2D(_MainTex, i.uv) - tex2D(_NegaTex, i.uv)*0.1;
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