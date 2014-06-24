Shader "Custom/White" {
	CGINCLUDE
		#include "UnityCG.cginc"
 
		fixed4 frag(v2f_img i) : COLOR{
			return 1.0;
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