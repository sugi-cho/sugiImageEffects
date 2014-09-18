Shader "Custom/PointParticle" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_C ("color", Color) = (1,1,1,1)
		_P ("power", Float) = 1
		_G ("gravity", Float) = 1
		_N ("num particle", Range(0,1)) = 1
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/Random.cginc"
		#include "Libs/Noise.cginc"
		#define PI 3.14159265359
		
		sampler2D _MainTex;
		half4 _C;
		half _P,_G,_N;
		
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
			half3 nois = snoise(v.vertex.xyz);
			half
				x = v.texcoord1.x,
				y = v.texcoord1.y,
				i = x + y * 256.0,
				t = frac(_Time.y/5-i)*5,
				r = rand(v.vertex.xyz);
			
			v.vertex.x *= 5.0;
			half3 
				vel0 = half3(
					v.vertex.x/20.0,
					1+v.vertex.y/2+r/2.0,
					0.2*(v.vertex.z+1)
				) * _P,
				gravity = half3(0,-1,0) * _G;
			
			v.vertex.xyz += vel0*t;
			v.vertex.xyz += gravity*t*t;
			v.vertex.xyz += nois * t;
			
			half3 turb = snoise(v.vertex.xyz*0.3 + half3(_Time.y,0,0));
			v.vertex.xyz += turb*saturate(v.vertex.y*0.3)*0.2;
			
//			half3 point = snoise3D(_Time.x);
//			v.vertex.y += t*saturate(1-distance(point.zx,v.vertex.zx));
			
			if(v.vertex.y < 0)
				v.vertex.y *= 0.1;
			v.vertex.y = abs(v.vertex.y);
			
			v.color.a = saturate(_N*256.0 - i);
			v.color.a *= saturate(1-t/5)*saturate(t*5.0);
			
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.wPos = mul(_Object2World, v.vertex).xyz;
			o.sPos = ComputeScreenPos(o.pos);
			o.cPos = mul(_Object2World, half4(0,0,0,1));
			o.color = v.color;
			o.texcoord = v.texcoord.xy;
			return o;
		}
		v2f vert2(appdata_full v){
			v.vertex.x += 0.3;
			return vert(v);
		}
		v2f vert3(appdata_full v){
			v.vertex.x -= 0.3;
			return vert(v);
		}
			
		half4 frag (v2f i) : COLOR
		{
			half4 c = _C * i.color;
			
			return c;
		}
	ENDCG
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha One
		Lighting Off ZWrite Off ZTest Always
		
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma target 3.0
			ENDCG 
		}
		Pass {
			CGPROGRAM
			#pragma vertex vert2
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma target 3.0
			ENDCG 
		}
		Pass {
			CGPROGRAM
			#pragma vertex vert3
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma target 3.0
			ENDCG 
		}
	}
}