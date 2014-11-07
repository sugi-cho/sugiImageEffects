Shader "Custom/uv" {
	CGINCLUDE
		#include "UnityCG.cginc"
		
		struct v2f {
			float4 pos : SV_POSITION;
			float2 texcoord : TEXCOORD0;
		};
 
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.texcoord = v.texcoord;
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			return half4(i.texcoord,0,1);
		}
	ENDCG
	
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG 
		}
	}
}