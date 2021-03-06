﻿// v2f
Shader "Custom/WorldColor" {
	Properties {
		_Color ("color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 3D) = "white" {}
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler3D _MainTex;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
			float3 wPos:TEXCOORD1;
		};
 
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.wPos = mul(_Object2World, v.vertex).xyz;
			o.color = v.color;
			o.texcoord = v.texcoord;
			return o;
		}
			
		fixed4 frag (v2f i) : COLOR
		{
			float4 c = tex3D(_MainTex, i.wPos+_Time.x).a;
			return c;
		}
	ENDCG
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma target 3.0
			#pragma glsl
			ENDCG 
		}
	}
}