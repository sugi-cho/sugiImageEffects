Shader "Custom/ProjectorBlend nxn" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NX ("num x", Float) = 1
		_NY ("num y", Float) = 1
		_OX ("overlap x", Float) = 0
		_OY ("overlap y", Float) = 0
		_O ("off set", Float) = 0
		_A ("prop A", Float) = 0.5
		_P ("prop P", Float) = 2
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		float _NX,_NY,_OX,_OY,_O,_A,_P;
		half4 _MainTex_TexelSize;
			
		fixed4 frag(v2f_img i) : COLOR{
			float2 uv = i.uv;
			half
				h = max(1,floor(_NX)),
				v = max(1,floor(_NY)),
				nx = floor(i.uv.x*h), //0,1,2,3...
				ny = floor(i.uv.y*v),
				b = 1.0;
			
			i.uv.x += _OX * ((h-1)/2.0-nx) / h;
			if(0 < nx)
				b *= saturate(frac(uv.x * h)/_OX);
			if(nx < h-1)
				b *= saturate((1-frac(uv.x * h))/_OX);
			
			i.uv.y += _OY * ((v-1)/2.0-ny) / v;
			if(0 < ny)
				b *= saturate(frac(uv.y * v)/_OY);
			if(ny < v-1)
				b *= saturate((1-frac(uv.y * v))/_OY);
			
			b = saturate(1.0 - (1.0-b)*(1+_O));
			if(b < 0.5)
				b = _A * pow(2*b,_P);
			else if(b < 1.0)
				b = 1 - (1.0-_A) * pow(2.0*(1.0-b),_P);
			
			return b * tex2D(_MainTex, i.uv);
		}
	ENDCG
	
	SubShader {
		ZTest Always
 
		pass{
			CGPROGRAM
			#pragma glsl
			#pragma target 3.0
			#pragma fragmentoption ARB_precision_NXint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	} 
}