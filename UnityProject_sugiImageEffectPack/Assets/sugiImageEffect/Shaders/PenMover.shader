Shader "Custom/PenMover" {
	Properties {
		_MainTex ("pen pos tex", 2D) = "black"{}
		_STex ("screen tex", 2D) = "black"{}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex,_STex;
		half4 _MainTex_TexelSize;
			
		half3 frag(v2f_img i) : COLOR{
//			return half3(i.uv,saturate(tex2D(_STex,i.uv).r));
			half2
				uv = tex2D(_MainTex, i.uv),
				pix = _MainTex_TexelSize.xy;
			half3 output = 0;
			half tmp = 0;
			for(int y = 0; y < 3; y++){
				for(int x = 0; x < 5; x++){
					half2 uv0 = uv + half2((x-2)*pix.x, (y-2)*pix.y);
					half c = tex2D(_STex, uv0).r;
					if(c > tmp)
						output = half3(uv0,c);
				}
			}
			return output;
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