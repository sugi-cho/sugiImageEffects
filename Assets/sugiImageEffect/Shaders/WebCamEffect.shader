Shader "Custom/WebCamEffect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_C ("target color", Color) = (1,0,0,1)
		_T ("thre", float) = 0.5
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/PhotoshopMath.cginc"
 
		sampler2D _MainTex;
		half _T;
		half4 _C;
		
		half4 _MainTex_TexelSize;
			
		fixed4 frag(v2f_img i) : COLOR{
			half4 c = tex2D(_MainTex, i.uv);
			half3 s = RGBToHSL(c.rgb);
			half3 d = RGBToHSL(_C.rgb);
			
			half r = ddx(s)+ddy(s);
			
			if(distance(s,d) > _T)
				c = 0;
			return c+r*r*100;
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