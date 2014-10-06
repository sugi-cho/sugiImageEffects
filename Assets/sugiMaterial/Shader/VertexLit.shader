Shader "Custom/VertexLit" {
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
		};
 
		v2f vert (appdata_full v)
		{
			half3 lightColor = ShadeVertexLights(v.vertex, v.normal);
			v.color.rgb = lightColor.rgb;
			
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.color = v.color;
			return o;
		}
		half4 frag (v2f i) : COLOR
		{
			return i.color;
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