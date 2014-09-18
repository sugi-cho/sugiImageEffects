Shader "Custom/PosTexToRT" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Offset ("offset", Vector) = (0,0,0,0)
		_Scale ("scale", Vector) = (1,1,1,1)
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half4 _Offset,_Scale;
		
		half4 _MainTex_TexelSize;
			
		half4 frag(v2f_img i) : COLOR{
#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0) 
				i.uv.y = 1-i.uv.y;
#endif
			half4
				c1 = tex2D(_MainTex, i.uv * half2(1.0, 0.5)),
				c2 = tex2D(_MainTex, 0.5 + i.uv * half2(1.0,0.5));
			
			half4 c = 1;
			c.rgb = c1.rgb + c2.rgb/256.0;
			c.rgb *= _Scale;
			c.rgb += _Offset;
			
			return c;
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