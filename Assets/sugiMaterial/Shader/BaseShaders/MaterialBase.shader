Shader "Custom/MaterialBase" {
	Properties {
		_Color ("color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("texture", 2D) = "white" {}
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
			
			float3 wPos : TEXCOORD1;
			float4 sPos : TEXCOORD2;
			float4 gPos : TEXCOORD3;
			
			float4 vPos : TEXCOORD4;
			float3 vNormal : TEXCOORD5;
			float3 wNormal : TEXCOORD6;
		};
 
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.color = v.color;
			o.texcoord = v.texcoord;
			
			o.wPos = mul(_Object2World, v.vertex).xyz;
			o.sPos = ComputeScreenPos(o.pos);
			o.gPos = ComputeGrabScreenPos(o.pos);
			
			o.vPos = v.vertex;
			o.vNormal = v.normal;
			o.wNormal = mul((float3x3)_Object2World, v.normal);
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			half2
				sUV = i.sPos.xy/i.sPos.w,
				gUV = i.gPos.xy/i.gPos.w;
			
			return half4(i.wNormal,1);
		}
	ENDCG
	
	SubShader {
		Tags {"LightMode" = "Vertex"}
		Pass {
			CGPROGRAM
			#pragma glsl
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG 
		}
	}
}