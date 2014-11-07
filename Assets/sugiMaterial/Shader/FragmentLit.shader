Shader "Custom/FragmentLit" {
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			
			float4 vPos : TEXCOORD0;
			float3 normal : TEXCOORD1;
		};
 
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.color = v.color;
			o.vPos = v.vertex;
			o.normal = v.normal;
			return o;
		}
		half4 frag (v2f i) : COLOR
		{
			//午後ティーを午前中に飲む
			half3 lightColor = ShadeVertexLights(i.vPos, i.normal);
			return half4(lightColor,1);
		}
	ENDCG
	
	SubShader {
		Tags {"LightMode" = "Vertex"}   
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