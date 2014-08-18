Shader "Custom/TextureSheetAnimator" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_TileX ("tile x", Float) = 1
		_TileY ("tile y", Float) = 1
		_T ("t",float) = 0
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		half _T;
		int _TileX, _TileY;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
		};
 
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.color = v.color;
			o.texcoord = v.texcoord;
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			half2 uv = i.texcoord / half2(_TileX, _TileY);
			_T = max(0,_T * _TileX*_TileY);
			half t = floor(_T);
			t = max(0,min(_TileX*_TileY-1,t));
			half t1 = max(0,min(_TileX*_TileY-1,t+1));
			
			half2 uv1 = uv + floor(half2(fmod(t,_TileX), t/_TileY)) / half2(_TileX,_TileY);
			half2 uv2 = uv + floor(half2(fmod(t1,_TileX), t1/_TileY)) / half2(_TileX,_TileY);
			
			half4 c = tex2D(_MainTex, uv1);
			half4 c1 = tex2D(_MainTex, uv2);
			return lerp(c,c1,frac(_T));
		}
	ENDCG
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaTest Greater .01
		Cull Off Lighting Off ZWrite Off
		
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG 
		}
	}
}