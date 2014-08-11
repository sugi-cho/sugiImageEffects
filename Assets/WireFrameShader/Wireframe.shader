Shader "Custom/Wireframe" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Gain ("Gain", Float) = 1.5
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "LightMode"="Vertex" }
//		Blend One One
//		ZWrite Off Cull Off
		LOD 200
		
		Pass {
			CGPROGRAM
			#pragma target 3.0
			#pragma glsl
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float _Gain;
			
			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
			};
			
			struct vs2ps {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 bary : TEXCOORD1;
			};
			
			vs2ps vert(appdata v) {
				vs2ps o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.bary = v.color.xyz;
				o.uv = v.uv;
				return o;
			}
			
			float4 frag(vs2ps i) : COLOR {
				float3 d = fwidth(i.bary.xyz);
				float3 a3 = smoothstep(float3(0.0,0.0,0.0), _Gain * d, i.bary);
				return 1-saturate(min(min(a3.x, a3.y), a3.z));
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}
