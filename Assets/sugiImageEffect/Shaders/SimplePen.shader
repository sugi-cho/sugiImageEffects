Shader "Custom/SimplePen" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Draw ("draw prop", Vector) = (0,0,1,1)
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		half4 _Draw;
			
		half frag(v2f_img i) : COLOR{
			half2 d = _MainTex_TexelSize.xy;
			i.uv.y *= d.x/d.y;
			_Draw.y *= d.x/d.y;
			half p = 0.001/distance(i.uv, _Draw.xy);
			return p*p*_Draw.z;
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