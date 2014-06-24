Shader "Custom/SimplePen" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ShapeTex ("brush shape", 2D) = "white" {}
		_Draw ("draw prop", Vector) = (0,0,1,1)
		_Prev ("prev pos", Vector) = (0,0,0,0)
		_D ("delta", float) = 0.1
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex, _ShapeTex;
		half4 _MainTex_TexelSize;
		half4 _Draw,_Prev;
		float _D;
			
		half frag(v2f_img i) : COLOR{
			half p = 0.01/distance(i.uv, _Draw.xy);
			return tex2D(_MainTex, i.uv) + p*p;
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