Shader "Custom/ViewPortNormal" {
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
			float3 vNormal : TEXCOORD1;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
		};
 
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.vNormal = mul(UNITY_MATRIX_MVP, half4(v.normal,0));
			o.color = v.color;
			o.texcoord = v.texcoord;
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			return half4(abs(normalize(i.vNormal)),1);
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