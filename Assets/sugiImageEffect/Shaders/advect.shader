Shader "Custom/FuildAdvect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
			
		half4 frag(v2f_img i) : COLOR{
			half2 pix = _MainTex_TexelSize.xy;
			half4
				c0 = tex2D(_MainTex, i.uv),
				c1 = tex2D(_MainTex, i.uv + half2(-pix.x/2,0)),
				c2 = tex2D(_MainTex, i.uv + half2(pix.x/2, 0)),
				c3 = tex2D(_MainTex, i.uv + half2(0,-pix.y/2)),
				c4 = tex2D(_MainTex, i.uv + half2(0, pix.y/2));
			
			c0.x += (c1.x - c2.x);
			c0.y += (c3.y - c4.y);
			
			
			half4 c = tex2D(_MainTex, i.uv - half2(c0.x, c0.y)*0.01)*0.999;
			
//			if((c.x > 0 && i.uv.x > 0.99) || (c.x < 0 && i.uv.x < 0.01))
//				c.x = -c.x;
//			if((c.y > 0 && i.uv.y > 0.99) || (c.y < 0 && i.uv.y < 0.01))
//				c.y = -c.y;
			
			return c;
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