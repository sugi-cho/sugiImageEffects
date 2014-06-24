Shader "Custom/SwingForce" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Prop ("prop(pos.xy, vel.xy)", Vector) = (0,0,0,0)
		_Radius ("radius", Float) = 1
		_Power ("draw power", Float) = 1
		_FactorP ("posFactor", Float) = 1
		_FactorV ("velFactor", Float) = 1
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half4 _Prop;
		half _Radius,_Power,_FactorP,_FactorV;
		
		half4 _MainTex_TexelSize;
		
			
		half2 frag(v2f_img i) : COLOR{
			half2
				pix = _MainTex_TexelSize.xy,
				pos = _Prop.xy * _FactorP,//pos(0-1)
				vel = _Prop.zw * _FactorV;
//			half d = distance(i.uv/pix, pos/pix)/_Radius;
//			half2 h = i.uv/pix - pos/pix;
//			h = (normalize(h)*d+vel*_Power) * min(1-saturate(d*d),0.5);
//			
//			return h;
//			
//			return vel * pow(saturate(1-d),2)*_Power;
			
			
			half p = saturate(_Radius/distance(i.uv/pix, pos/pix));
			return p*p * (normalize(i.uv-pos+vel)) * _Power;
		}
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off } 
 
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma target 3.0
			#pragma glsl
			ENDCG
		}
	} 
}