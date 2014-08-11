Shader "Custom/ProjectorBlend2-1"{
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_W ("overlap width", Float) = 0
		_O ("off set", Float) = 0
		_A ("prop A", Float) = 0.5
		_P ("prop P", Float) = 2
	}

		
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		float _W,_O,_A,_P;
		half4 _MainTex_TexelSize;
			
		fixed4 frag(v2f_img i) : COLOR{
			float2 uv = i.uv;
			float2 uv1 = uv;
			float b = 1.0;
			
			if(uv.x < 0.5){
				uv1.x += _W;
				if(0.5 - _W < uv1.x){
					b *= 1 - (uv.x - 0.5 + 2 * _W) / (2 * _W);
				}
			}
			else{
				uv1.x -= _W;
				if(uv1.x < 0.5 + _W){
					b *= (uv.x - 0.5) / (2 * _W);
				}
			}
			
			if(0.5 - 2 * _W < uv.x && uv.x < 0.5 + 2 * _W){
				if(b < 0.5){
					b *= _A * pow((2 * b), _P);
				}
				else{
					b *= 1 - (1 - _A) * pow((2 * (1 - b)), _P);
				}
			}
			
			if(uv1.x < 0 || 1 < uv1.x || uv1.y < 0 || 1 < uv1.y){
				b *= 0;
			}
			
			return b * tex2D(_MainTex, uv1);
		}
	ENDCG
	
	SubShader {
		ZTest Always
 
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	} 
}
