Shader "Custom/QuadWarp" {
	Properties {
		_BL ("bottom left", Vector) = (0,0,0,0)
		_BR ("bottom right", Vector) = (1,0,0,0)
		_UL ("upper left", Vector) = (0,1,0,0)
		_UR ("upper right", Vector) = (1,1,0,0)
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		uniform half4 _Prop1, _Prop2;
		uniform sampler2D _BlendedTex;
		
		half4 _BL,_BR,_UL,_UR;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
			float3 wPos : TEXCOORD1;
			float4 sPos : TEXCOORD2;
			float3 cPos : TEXCOORD3;
		};
 
		v2f vert (appdata_full v)
		{
			half3 pos = v.vertex.xyz;
			half2
				p1 = lerp(_BL,_BR,pos.x),
				p2 = lerp(_UL,_UR,pos.x);
			pos.xy = lerp(p1,p2,pos.y);
			pos.xy *= _Prop2.zw;
			pos.xy += _Prop2.xy * _Prop2.zw;
			pos.xy -= 0.5;
			pos.xy *= _Prop1.xy*2.0;
			v.vertex.xyz = pos;
			
			v.texcoord.xy *= _Prop2.zw;
			v.texcoord.xy += _Prop2.xy * _Prop2.zw;
			
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.wPos = mul(_Object2World, v.vertex).xyz;
			o.sPos = ComputeScreenPos(o.pos);
			o.cPos = mul(_Object2World, half4(0,0,0,1));
			o.color = v.color;
			o.texcoord = v.texcoord;
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			return tex2D(_BlendedTex, i.texcoord);
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