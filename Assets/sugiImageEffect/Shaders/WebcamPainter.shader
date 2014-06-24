Shader "Custom/WebcamPainter" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_WTex ("webcam", 2D) = "black"{}
		_PTex ("points", 2D) = "black"{}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex,_WTex,_PTex;
		half4 _MainTex_TexelSize;
			
		half4 frag(v2f_img i) : COLOR{
			half2 pix = _MainTex_TexelSize.xy;
			half4
				m = tex2D(_MainTex, i.uv),
				m1 = tex2D(_MainTex, i.uv + half2(-pix.x,0)),
				m2 = tex2D(_MainTex, i.uv + half2(pix.x, 0)),
				m3 = tex2D(_MainTex, i.uv + half2(0,-pix.y)),
				m4 = tex2D(_MainTex, i.uv + half2(0, pix.y)),
				w = tex2D(_WTex, i.uv),
				c = 0;
			m = m/2 + (m1+m2+m3+m4)/8;
//			half4[64] vs;
			for(int y = 0; y < 8; y++){
				for(int x = 0; x < 8; x++){
//					int i = y*8+x;
					half4 v = tex2D(_PTex, half2(x/8.0,y/8.0));
					half d = distance(i.uv/pix, v.xy/pix);
					c += 10/(d*d) * v.z;
				}
			}
			half2 dd = half2(ddx(m.r), ddy(m.r));
			m = tex2D(_MainTex, i.uv - dd * pix);
			m*= 0.9;
			return m+c;
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