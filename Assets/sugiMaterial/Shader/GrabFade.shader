Shader "Custom/GrabFade" {
	Properties {
		_Color ("color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("texture", 2D) = "white" {}
		_L ("level of fader", Float) = 0
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex,_BackGrabTex;
		fixed4 _Color;
		half _L;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
			float3 wPos : TEXCOORD1;
			float4 gPos : TEXCOORD2;
		};
 
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.wPos = mul(_Object2World, v.vertex).xyz;
			o.gPos = ComputeGrabScreenPos(o.pos);
			o.color = v.color;
			o.texcoord = v.texcoord;
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			half2 gUV = i.gPos;
			half4 c = _Color;
			half4 b = tex2D(_BackGrabTex, gUV);
			return lerp(b,c,saturate(i.wPos.y-_L));
		}
	ENDCG
	
	SubShader {
		
		GrabPass{"_BackGrabTex"}
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG 
		}
	}
}