Shader "Custom/ImageEffectBase" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		
		struct v2f 
		{
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			float2 uv1 : TEXCOORD1;
		};
		
		v2f vert (appdata_img v) 
		{
			v2f o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv.xy = v.texcoord;
			o.uv1.xy = v.texcoord;

			#if UNITY_UV_STARTS_AT_TOP 
			if (_MainTex_TexelSize.y < 0)
				o.uv1.y = 1-o.uv1.y;		
			#else
			
			#endif
			  
			return o;
		} 
			
		half4 frag(v2f i) : COLOR{
			return tex2D(_MainTex, i.uv);
		}
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }
 
		pass{
			CGPROGRAM
			#pragma glsl
			#pragma target 3.0
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	} 
}