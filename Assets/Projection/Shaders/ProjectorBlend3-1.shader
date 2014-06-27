Shader "Custom/ProjectorBlend3-1"{
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
			float2 uvFrom = i.uv;
			float b = 1.0;
			
			if(uvFrom.x < 1.0/3.0){
				i.uv.x += _W;
				b *= saturate((1.0/3.0 - uvFrom.x)/_W);
			}
			else if(uvFrom.x < 2.0/3.0){
				i.uv = i.uv;
				b *= saturate(abs(1.0/3.0-uvFrom.x)/_W) * saturate(abs(2.0/3.0 - uvFrom.x)/_W); 
			}
			else{
				i.uv.x -= _W;
				b *= saturate(abs(2.0/3.0 - uvFrom.x)/_W);
			}
			
			b = saturate(1.0 - (1.0-b)*_O);
			if(b < 0.5)
				b = _A * pow(2*b,_P);
			else if(b < 1.0)
				b = 1 - (1.0-_A) * pow(2.0*(1.0-b),_P);
			
			return b * tex2D(_MainTex, i.uv);
		}
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }  
		ColorMask RGB
 
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	} 
}
