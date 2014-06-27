Shader "Custom/FadeCutoff" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		_P1 ("p1", Float) = 0
		_P2 ("p2", Float) = 0
		_P3 ("p3", Float) = 0
		_P4 ("p4", Float) = 0
		
		_P5 ("p5", Float) = 0
		_P6 ("p6", Float) = 0
		_P7 ("p7", Float) = 0
		_P8 ("p8", Float) = 0
		
		_P9 ("p9", Float) = 0
		_P10 ("p10", Float) = 0
	}
	SubShader {
		pass{
			ZTest Always Cull Off ZWrite Off
			Fog { Mode off }  
			ColorMask RGB	
			CGPROGRAM
    		#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma target 3.0
			#pragma glsl
			
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			
			fixed
			_P1,_P2,_P3,_P4,_P5,_P6,_P7,_P8,_P9,_P10;

			half4 _MainTex_TexelSize;
			
			fixed4 frag(v2f_img i) : COLOR{
				float2 uv = i.uv;
				float2 uv2 = uv;
				#if UNITY_UV_STARTS_AT_TOP
				if(_MainTex_TexelSize.y<0.0)
					uv2.y = 1.0-uv2.y;
				#endif
				
				float2 d = _MainTex_TexelSize.xy;
				fixed4 c = tex2D(_MainTex, uv);
				
				float
					x = uv2.x,
					y = uv2.y;
				if(x < 1.0/3.0){
					if(y < lerp(_P1,_P2,x*3))
						c *= saturate(1-(lerp(_P1,_P2,x*3)-y)/abs(d.y));
					else if(y > lerp(1-_P5,1-_P6,x*3))
						c *= saturate(1-(y-lerp(1-_P5,1-_P6,x*3))/abs(d.y));
				}
				else if(x < 2.0/3.0){
					if(y < lerp(_P2,_P3,(x-1.0/3.0)*3))
						c *= saturate(1-(lerp(_P2,_P3,(x-1.0/3.0)*3)-y)/abs(d.y));
					else if(y > lerp(1-_P6,1-_P7,(x-1.0/3.0)*3))
						c *= saturate(1-(y-lerp(1-_P6,1-_P7,(x-1.0/3.0)*3))/abs(d.y));
				}
				else{
					if(y < lerp(_P3,_P4,(x-2.0/3.0)*3))
						c *= saturate(1-(lerp(_P3,_P4,(x-2.0/3.0)*3)-y)/abs(d.y));
					else if(y > lerp(1-_P7,1-_P8,(x-2.0/3.0)*3))
						c *= saturate(1-(y-lerp(1-_P7,1-_P8,(x-2.0/3.0)*3))/abs(d.y));
				}
				
				if(x < _P9)
					c*=0;
				if(x > 1-_P10)
					c*=0;
				
				
				return c;
			}
			ENDCG
		}
	} 
}