// blur, no down sample, fullscreen mobile blur
Shader "Custom/sugiBlur" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Size ("blur size", Float) = 0.1
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half _Size;
		half4 _MainTex_TexelSize;
		
		static const half curve[7] = { 0.0205, 0.0855, 0.232, 0.324, 0.232, 0.0855, 0.0205 };
		
		struct v2f_withBlurCoords8 
		{
			float4 pos : SV_POSITION;
			half4 uv : TEXCOORD0;
			half2 offs : TEXCOORD1;
		};
		
		v2f_withBlurCoords8 vertBlurHorizontal (appdata_img v)
		{
			v2f_withBlurCoords8 o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv = half4(v.texcoord.xy,1,1);
			o.offs = _MainTex_TexelSize.xy * half2(1.0, 0.0) * _Size;

			return o; 
		}
		
		v2f_withBlurCoords8 vertBlurVertical (appdata_img v)
		{
			v2f_withBlurCoords8 o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv = half4(v.texcoord.xy,1,1);
			o.offs = _MainTex_TexelSize.xy * half2(0.0, 1.0) * _Size;
			 
			return o; 
		}	

		half4 frag ( v2f_withBlurCoords8 i ) : COLOR
		{
			half2 uv = i.uv.xy; 
			half2 netFilterWidth = i.offs;  
			half2 coords = uv - netFilterWidth * 3.0;  
			
			half4 color = 0;
  			for( int l = 0; l < 7; l++ )  
  			{   
				half4 tap = tex2D(_MainTex, coords);
				color += tap * curve[l];
				coords += netFilterWidth;
  			}
			return color;
		}
		
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }  
		
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vertBlurHorizontal
			#pragma fragment frag
			ENDCG
		}
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vertBlurVertical
			#pragma fragment frag
			ENDCG
		}
	} 
}