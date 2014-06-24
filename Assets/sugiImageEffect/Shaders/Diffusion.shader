Shader "Custom/Diffusion" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Speed ("speed", Float) = 1
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half _Speed;
		half4 _MainTex_TexelSize;
			
		fixed4 frag(v2f_img i) : COLOR{
			float
				x = _MainTex_TexelSize.x,
				y = _MainTex_TexelSize.y;
			half4
				c = tex2D(_MainTex, i.uv),
				
				c1 = tex2D(_MainTex, i.uv+float2(-x, y));
				c1 +=tex2D(_MainTex, i.uv+float2( 0, y));
				c1 +=tex2D(_MainTex, i.uv+float2( x, y));
				c1 +=tex2D(_MainTex, i.uv+float2(-x, 0));
				
				c1 +=tex2D(_MainTex, i.uv+float2( x, 0));
				c1 +=tex2D(_MainTex, i.uv+float2(-x,-y));
				c1 +=tex2D(_MainTex, i.uv+float2( 0,-y));
				c1 +=tex2D(_MainTex, i.uv+float2( x,-y));
			c1 /= 8;
			c = lerp(c, c1,unity_DeltaTime.x * _Speed);
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
			ENDCG
		}
	} 
}
