Shader "Custom/Height2Flow" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
			
		fixed4 frag(v2f_img i) : COLOR{
			half r = tex2D(_MainTex, i.uv).r;
			return half4(6*ddx(r)+0.5, 6*ddy(r)+0.5,1,1);
			
			half2 pix = _MainTex_TexelSize.xy;
			half c[9] = {0,0,0,0,0,0,0,0,0};
			
			for(int y = 0; y < 3; y++)
				for(int x = 0; x < 3; x++)
					c[y*3+x] = tex2D(_MainTex, i.uv + half2(pix.x*(x-1), pix.y*(y-1))).r;
					//[0,1,2,
					// 3,4,5,
					// 6,7,8]
			
			half2 flow = half2(3*c[4]-c[0]-c[3]-c[6] +c[2]+c[5]+c[8]-3*c[4], 3*c[4]-c[6]-c[7]-c[8] +c[0]+c[1]+c[2]-3*c[4]);
			
			return half4((1-5*flow)*0.5,1,1);
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