Shader "VertexAnim/oneshot" {
	Properties {
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_AnimTex ("PosTex", 2D) = "white" {}
		_Scale ("scale", Vector) = (1,1,1,1)
		_Delta ("Delta", Vector) = (0,0,0,0)
		_AnimEnd ("End Time", float) = 30
		_Speed ("Animation Speed(fps)", float) = 30
		_T ("Time", float) = 0
	}
	
	CGINCLUDE
		#include "UnityCG.cginc"
		struct appdata {
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
		};
		
		sampler2D _MainTex;
		sampler2D _AnimTex;
		
		float4 _Scale;
		float4 _Delta;
		float _AnimEnd;
		float _Speed;
		float _T;
		
		half4 _AnimTex_TexelSize;
		
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
			float t = max(0,min(_AnimEnd*30/_Speed, _Time.y - _T));
			float time = t;
			
			float t1 = floor(t);
			float t2 = min(_AnimEnd*30/_Speed, floor(t + 1));
			t = t-t1;
			
			v.texcoord1.y = _Speed*t1*_AnimTex_TexelSize.y;
			float3 pos1 = tex2Dlod(_AnimTex, v.texcoord1).rgb;
			v.texcoord1.y += 0.5;
			float3 pos2 = tex2Dlod(_AnimTex, v.texcoord1).rgb;
			float3 pos = float3(
				(pos1.r + pos1.g/256.0)*_Scale.x+_Delta.x,
				(pos1.b + pos2.r/256.0)*_Scale.y+_Delta.y,
				(pos2.g + pos2.b/256.0)*_Scale.z+_Delta.z
			);
			
			v.texcoord1.y = _Speed*t2*_AnimTex_TexelSize.y;
			pos1 = tex2Dlod(_AnimTex, v.texcoord1).rgb;
			v.texcoord1.y += 0.5;
			pos2 = tex2Dlod(_AnimTex, v.texcoord1).rgb;
			pos2 = float3(
				(pos1.r + pos1.g/256.0)*_Scale.x+_Delta.x,
				(pos1.b + pos2.r/256.0)*_Scale.y+_Delta.y,
				(pos2.g + pos2.b/256.0)*_Scale.z+_Delta.z
			);
			
			v.vertex.xyz += lerp(pos, pos2, t);
			
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.wPos = mul(_Object2World, v.vertex).xyz;
			o.sPos = ComputeScreenPos(o.pos);
			o.cPos = mul(_Object2World, half4(0,0,0,1));
			o.color = v.color;
			o.texcoord = v.texcoord;
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			return tex2D(_MainTex, i.texcoord);
		}

	ENDCG

	SubShader { 
		Tags { "RenderType"="Opaque" "Queue"="Geometry"}
		LOD 700
		Cull Off
		
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
