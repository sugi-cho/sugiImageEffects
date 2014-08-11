Shader "Custom/XYTest" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_T ("T", float) = 0.5
		_H ("H", float) = 0.9
		_V1 ("velocity(t=0)",float) = 1
		_V2 ("velocity(t=T)",float) = 0
		_V3 ("velocity(t=1)",float) = 1
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/CoonsCurve.cginc"
 
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		half _T,_H,_V1,_V2,_V3;
			
		fixed4 frag(v2f_img i) : COLOR{
			half y = i.uv.x;
			if(y < _T)
				y = coons(i.uv.x/_T,0,_H,_V1*_T,_V2*_T);
			else
				y = coons((i.uv.x-_T)/(1-_T),_H,1,_V2*(1-_T),_V3*(1-_T));
			
			return i.uv.y > y;
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