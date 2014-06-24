Shader "Custom/SwingVelocity" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "brack" {}
		_InclTex ("inclination", 2D) = "brack" {} //katamuki
		_Force ("force texture", 2D) = "brack" {}
		_Noise ("3d noise", 3D) = "brack"{}
		_Amp ("force amp", Float) = 1.0
		_Damp ("vel damp", Float) = 0.8
		_Bane ("bane power", Float) = 0.8
		_MaxVel ("max velocity", Float) = 2.0
	}
	CGINCLUDE
// Upgrade NOTE: excluded shader from DX11 and Xbox360 because it uses wrong array syntax (type[size] name)
#pragma exclude_renderers d3d11 xbox360
		#include "UnityCG.cginc"
 
		sampler2D _MainTex, _InclTex, _Force;
		sampler3D _Noise;
		half4 _MainTex_TexelSize;
		half _Amp,_Damp,_Bane,_MaxVel;
			
		half2 frag(v2f_img i) : COLOR{
			
			half2
				force = tex2D(_Force, i.uv).xy * _Amp,
				vel = 0,
				incl = tex2D(_InclTex, i.uv).xy,
				pix = _MainTex_TexelSize.xy;
//			half2[9] vs = {
//				half2(0,0),half2(0,0),half2(0,0),
//				half2(0,0),half2(0,0),half2(0,0),
//				half2(0,0),half2(0,0),half2(0,0)
//			};
//			for(int y=0; y<3; y++){
//				for(int x=0; x<3; x++){
//					int index = y*3+x;
//					vs[index] += tex2D(_MainTex, i.uv + half2((x-1)*pix.x, (y-1)*pix.y)).xy;
//					vel += vs[index];
//					//[0,1,2
//					// 3,4,5
//					// 6,7,8]
//					
//				}
//			}
//			vel = vel/9+force;
			half4
				c0 = tex2D(_MainTex, i.uv),
				c1 = tex2D(_MainTex, i.uv + half2(-pix.x,0)),
				c2 = tex2D(_MainTex, i.uv + half2(pix.x, 0)),
				c3 = tex2D(_MainTex, i.uv + half2(0,-pix.y)),
				c4 = tex2D(_MainTex, i.uv + half2(0, pix.y));
			
			vel = (c0+c1+c2+c3+c4)/5 + force;
			vel += (half2(
				tex3D(_Noise,half3((i.uv/3+half2(_Time.x*0.4,3))*0.4,_Time.x)).w,
				tex3D(_Noise,half3((i.uv/2+half2(3,_Time.x*0.2))*0.4,-_Time.x)).w
			)-0.5)*0.2;
			
//			half2 v = lerp(vel,vs[1],saturate((-vs[1]+vel)*1000));
//			v += lerp(vel,vs[3],saturate((vs[3]-vel)*1000));
//			v += lerp(vel,vs[5],saturate((-vs[5]+vel)*1000));
//			v += lerp(vel,vs[7],saturate((vs[7]-vel)*1000));
			
			vel = lerp(vel, -incl, _Bane);
			
			return vel;
		}
		half2 frag2(v2f_img i):COLOR{
			half2 pix = _MainTex_TexelSize.xy;
			half4
				c0 = tex2D(_MainTex, i.uv),
				c1 = tex2D(_MainTex, i.uv + half2(-pix.x,0)),
				c2 = tex2D(_MainTex, i.uv + half2(pix.x, 0)),
				c3 = tex2D(_MainTex, i.uv + half2(0,-pix.y)),
				c4 = tex2D(_MainTex, i.uv + half2(0, pix.y));
			
			c0.x += (c1.x - c2.x);
			c0.y += (c3.y - c4.y);
			
			return tex2D(_MainTex, i.uv - half2(c0.x, c0.y)*pix*1.0)*_Damp;
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
			#pragma target 3.0
			#pragma glsl
			ENDCG
		}
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag2
			#pragma target 3.0
			#pragma glsl
			ENDCG
		}
	} 
}