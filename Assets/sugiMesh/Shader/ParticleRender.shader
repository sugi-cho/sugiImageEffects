Shader "Custom/ParticleRender" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Velocity ("velocity", 2D) = "black"{}
		_Position ("position", 2D) = "black"{}
		_Direction ("direction", 2D) = "black"{}
		_Scale ("scale", 2D) = "white"{}
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/Transform.cginc"
		#define PI 3.14159265359
		sampler2D _MainTex,_Velocity,_Position,_Direction,_Scale;
		
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
				scale = tex2Dlod(_Scale, v.texcoord1);
				
			half3 shape = v.vertex.xyz;
			
			direction = position;
			direction.w = v.texcoord1.x + v.texcoord1.y;
			
			half
				yaw = atan2(direction.x, direction.z),
				pitch = -atan2(direction.y, length(direction.xz)),
				roll = -direction.w * 2 * PI;
			
			shape = rotateZ(shape, roll);
			shape = rotateX(shape, pitch);
			shape = rotateY(shape, yaw);
			
			scale = 0.05;
			
			v.vertex.xyz = position.xyz + shape * scale.xyz;
			
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
			half4 c = 0;
			if(i.lPos.x >= 0.5){
				c += half4(1,0,0,1);
			}
			if(i.lPos.x <= -0.5){
				c += half4(0,1,1,1);
			}
			if(i.lPos.y >= 0.5){
				c += half4(0,1,0,1);
			}
			if(i.lPos.y <= -0.5){
				c += half4(1,0,1,1);
			}
			if(i.lPos.z >= 0.5){
				c += half4(0,0,1,1);
			}
			if(i.lPos.z <= -0.5){
				c += half4(1,1,0,1);
			}
			
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