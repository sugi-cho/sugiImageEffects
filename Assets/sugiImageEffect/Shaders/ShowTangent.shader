Shader "Custom/ShowTangent" {
	Properties {
		_Color ("color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
		};
 
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.color.rgb = normalize(mul(UNITY_MATRIX_MVP, half4(v.tangent.xyz,0))).xyz;
//			o.color.rgb = mul(_Object2World, half4(v.tangent.xyz,0)).xyz;
			o.texcoord = v.texcoord;
			return o;
		}
			
		fixed4 frag (v2f i) : COLOR
		{
			return i.color;
		}
	ENDCG
	
	SubShader {
		
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG 
		}
	}
}