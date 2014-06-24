Shader "Custom/FractalEffect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/Noise.cginc"
		#include "Libs/Random.cginc"
 
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
			
		half frag(v2f_img i) : COLOR{
			half n = 0;
			half2 uv = i.uv;
			uv.x *= 16.0/9.0;
			uv.x += _Time.x/2;
			uv = floor(uv*30.0)/50.0;
			n += snoise(half3(uv*5.0,_Time.y*0.5));
			n = floor(n*50.0)/50.0;
			n *= frac(rand(uv)+_Time.x);
			
			half n1 = 0;
			uv = i.uv*0.7;
			uv.x *= 16.0/9.0;
			uv.y += _Time.x;
			uv = floor(uv*30.0)/50.0;
			n1 += snoise(half3(uv*5.0,_Time.y));
			n1 = floor(n*50.0)/50.0;
			n1 *= frac(rand(uv)+_Time.x*2.0);
			
			return n - n1;
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
			#pragma target 3.0
			#pragma glsl
			ENDCG
		}
	} 
}