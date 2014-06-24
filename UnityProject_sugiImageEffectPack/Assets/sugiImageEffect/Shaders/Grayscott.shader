Shader "Custom/Grayscott" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 		float _delta,_distance,_k,_f;
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
			
		fixed4 frag(v2f_img i) : COLOR{
			float2 pix = _MainTex_TexelSize.xy;
			
			return tex2D(_MainTex, i.uv);
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