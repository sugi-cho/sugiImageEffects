Shader "Custom/ParticleWithNoise" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Velocity ("velocity", 2D) = "black"{}
		_Position ("position", 2D) = "black"{}
		_Direction ("direction", 2D) = "black"{}
		_Scale ("scale", 2D) = "black"{}
		_D ("directon", Vector) = (1,0,0,0)
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/Transform.cginc"
		#include "Libs/Noise.cginc"
		#define PI 3.14159265359
		sampler2D _MainTex,_Velocity,_Position,_Direction,_Scale;
		half4 _D;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
			float3 wPos : TEXCOORD1;
			float4 sPos : TEXCOORD2;
			float3 cPos : TEXCOORD3;
			float3 lPos :TEXCOORD4;
			float3 normal : TEXCOORD5;
		};
 
		v2f vert (appdata_full v)
		{
			half3 pos = v.vertex.xyz;
			half4
				velocity = tex2Dlod(_Velocity, v.texcoord1),
				position = tex2Dlod(_Position, v.texcoord1),
				direction = tex2Dlod(_Direction, v.texcoord1),
				scale = tex2Dlod(_Scale, v.texcoord1),
				shape = v.vertex;
			
			//** Write From Here pos direction shape **//
			
			position.xyz = half3(v.texcoord1.xy*half2(64,128),0);
			half2 n = snoise(v.texcoord1*5) * 4;
			n *= n;
			position.xy += n;
			scale.xyz = 1;
			
			//** To Here **//
			
			half
				yaw = atan2(direction.x, direction.z),
				pitch = -atan2(direction.y, length(direction.xz)),
				roll = -direction.w * 2 * PI;
			shape.xyz = rotateZ(shape.xyz, roll);
			shape.xyz = rotateX(shape.xyz, pitch);
			shape.xyz = rotateY(shape.xyz, yaw);
			
			v.vertex.xyz = position.xyz + shape*scale.xyz;
			
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.wPos = mul(_Object2World, v.vertex).xyz;
			o.lPos = pos;
			o.sPos = ComputeScreenPos(o.pos);
			o.cPos = mul(_Object2World, half4(0,0,0,1));
			o.color = v.color;
			o.texcoord = v.texcoord.xy;
			o.normal = v.normal;
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			half4 c = 0.5;
			
			half2 uv = i.texcoord;
			uv = abs(2.0*uv-1.0);
			half l = max(uv.x,uv.y);
			l = smoothstep(0.85, 1, l);
			
			return c;
		}
	ENDCG
	
	SubShader {
		Lighting Off
		
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