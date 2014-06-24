Shader "Custom/SwingInclination" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "brack" {}
		_VelTex ("velocity tex", 2D) = "brack" {}
		_Max ("max inclination", Float) = 3.0
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex, _VelTex;
		half4 _MainTex_TexelSize;
		half _Max;
			
		half2 frag(v2f_img i) : COLOR{
			half2
				incle = tex2D(_MainTex, i.uv).xy,
				vel = tex2D(_VelTex, i.uv).xy,
				mx = half2(_Max,_Max);

			incle = max(-mx,min(mx,incle + vel*0.95));
			return incle*0.99;
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