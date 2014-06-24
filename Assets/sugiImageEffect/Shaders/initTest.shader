// imageEffect
Shader "Custom/initTest" {
	CGINCLUDE
		#include "UnityCG.cginc"
		
		half4 check(float2 uv){
			half2 d = 1.0/9.0;
			half4 c;
			c.r = (2*fmod(uv.x, d.x))/d.x-1;
			c.g = (2*fmod(uv.y, d.y))/d.y-1;
			return ceil(c.r*c.g);
		}
		
		fixed4 frag(v2f_img i) : COLOR{
			return check(i.uv);
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
			#pragma target 3.0
			#pragma glsl
			ENDCG
		}
	} 
}