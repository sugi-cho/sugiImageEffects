Shader "Custom/Spot" {
	Properties {
		_Color ("color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("texture", 2D) = "white" {}
		_P ("power", Float) = 1.5
		
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		fixed4 _Color;
		half _P;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
			float3 wPos : TEXCOORD1;
			float4 sPos : TEXCOORD2;
			float3 cPos : TEXCOORD3;
		};
 
		v2f vert (appdata_full v)
		{
			v.vertex.y*=1.2;
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.texcoord = v.texcoord;
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			half d = distance(i.texcoord,half2(0.5,0.5));
			return saturate(1-pow(2*d,_P))*_Color;
		}
	ENDCG
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend One One
		Cull Off Lighting Off ZWrite Off
		
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG 
		}
	}
}