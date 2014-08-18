Shader "Custom/ParticleRender" {
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
			float3 normal : TEXCOORD4;
		};
 
		v2f vert (appdata_full v)
		{
			half4
				velocity = tex2Dlod(_Velocity, v.texcoord1),
				position = tex2Dlod(_Position, v.texcoord1),
				direction = tex2Dlod(_Direction, v.texcoord1),
				scale = tex2Dlod(_Scale, v.texcoord1),
				shape = v.vertex;
			direction = half4(v.texcoord1.xy,-v.texcoord1.xy);
			half
				yaw = atan2(direction.x, direction.z),
				pitch = -atan2(direction.y, length(direction.xz)),
				roll = -direction.w * 2 * PI;
			half z = shape.z+0.5;
			
			shape.xyz = rotateZ(shape.xyz, roll);
			shape.xyz = rotateX(shape.xyz, pitch);
			shape.xyz = rotateY(shape.xyz, yaw);
			
			position.xyz = half3(v.texcoord1.xy*1.5,0)*half3(32,64,1);
			scale.xyz = 1;//v.texcoord1.x+v.texcoord1.y;
//			scale.xyz *= scale.w;
			
			v.vertex.xyz = position.xyz + shape*scale.xyz;
			
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.wPos = mul(_Object2World, v.vertex).xyz;
			o.sPos = ComputeScreenPos(o.pos);
			o.cPos = mul(_Object2World, half4(0,0,0,1));
			o.color = lerp(half4(0,0,0,1),half4(1,0,0,1),z);
			o.texcoord = v.texcoord.xy;
			o.normal = v.normal;
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			half2 uv = i.texcoord;
			uv = abs(2.0*uv-1.0);
			half line = max(uv.x,uv.y);
//			return line;
			line = smoothstep(0.985, 1, line);
			return line;
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