// v2f
Shader "Custom/ParticleScreenTex" {
	Properties {
		_Color ("color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("color Texture(screen)", 2D) = "white" {}
		_AlphaTex ("alpha texture(uv)", 2D) = "white" {}
	}
 
	CGINCLUDE
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members screenPos)
#pragma exclude_renderers d3d11 xbox360
		#include "UnityCG.cginc"
		sampler2D _MainTex,_AlphaTex;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			float4 screenPos;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
		};
 
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.screenPos = ComputeScreenPos(o.pos);
			o.color = v.color;
			o.texcoord = v.texcoord;
			return o;
		}
			
		fixed4 frag (v2f i) : COLOR
		{	
			float2 screenUV = i.screenPos.xy / i.screenPos.w;
			half4 c = tex2D(_MainTex, screenUV);
			c.a = tex2D(_AlphaTex, i.texcoord)*i.color.a;
			return c;
		}
	ENDCG
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
//		AlphaTest Greater .01
		Cull Off Lighting Off ZWrite Off
		
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