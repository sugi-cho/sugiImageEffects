Shader "Custom/Fresnel" {
	Properties {
		_Color ("color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("texture", 2D) = "white" {}
		_P ("power", Float) = 1.5
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex,_GrabTexture;
		fixed4 _Color;
		half _P;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
			
			float3 wPos : TEXCOORD1;
			float4 sPos : TEXCOORD2;
			float4 gPos : TEXCOORD3;
			
			float4 vPos : TEXCOORD4;
			float3 vNormal : TEXCOORD5;
			float3 wNormal : TEXCOORD6;
			float3 viewNormal : TEXCOORD7;
		};
 
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.color = v.color;
			o.texcoord = v.texcoord;
			
			o.wPos = mul(_Object2World, v.vertex).xyz;
			o.sPos = ComputeScreenPos(o.pos);
			o.gPos = ComputeGrabScreenPos(o.pos);
			
			o.vPos = v.vertex;
			o.vNormal = v.normal;
			o.wNormal = mul((float3x3)_Object2World, SCALED_NORMAL);
			o.viewNormal = mul(UNITY_MATRIX_MVP, half4(v.normal,0));
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			half2
				sUV = i.sPos.xy/i.sPos.w,
				gUV = i.gPos.xy/i.gPos.w;
			half3 viewDir = normalize(_WorldSpaceCameraPos - i.wPos.xyz);
			half fresnel = saturate(1- dot(viewDir,i.wNormal));
			fresnel = pow(fresnel,_P);
			half4 c = tex2D(_GrabTexture, gUV + i.viewNormal*fresnel*0.1);
			return c+fresnel*_Color;
			
			return half4(i.viewNormal*fresnel,1);
			return half4(viewDir,1);
		}
	ENDCG
	
	SubShader {
		GrabPass{}
		Tags {"LightMode" = "Vertex" "Queue" = "Transparent"}
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