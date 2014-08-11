Shader "Custom/ShowTangent" {
	Properties {
		_Color ("color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_F("fall", Float) = 0
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/Random.cginc"
		#include "Libs/Transform.cginc"
		
		sampler2D _MainTex;
		half _F;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
			float3 bary : TEXCOORD1;
		};
 
		v2f vert (appdata_full v)
		{
			half3 center = v.tangent.xyz;
			half t = max(0,_F-rand(center));
			v.vertex.xyz = rotate(v.vertex.xyz, normalize(center), t*10, center);
			
			v.vertex.y -= 4.9*t*t;
			v.vertex.xyz += 5*v.tangent.xyz*t;
			
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.bary = v.color.rgb;
			o.color = v.normal.y/2+0.5;
			o.texcoord = v.texcoord;
			return o;
		}
		
		v2f vert2(appdata_full v){
			v.normal.xyz = -v.normal.xyz;
			return vert(v);
		}
			
		fixed4 frag (v2f i) : COLOR
		{
			float3 d = fwidth(i.bary.xyz);
			float3 a3 = smoothstep(float3(0.0,0.0,0.0), 1.0 * d, i.bary);
			half4 c = i.color;
			return c * saturate(min(min(a3.x, a3.y), a3.z));
		}
	ENDCG
	
	SubShader {
		Cull Back
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma target 3.0
			#pragma glsl
			ENDCG 
		}
		Cull Front
		Pass {
			CGPROGRAM
			#pragma vertex vert2
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma target 3.0
			#pragma glsl
			ENDCG 
		}
	}
}