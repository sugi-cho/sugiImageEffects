Shader "Custom/BrushTest" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ShapeTex ("brush tex", 2D) = "white" {}
		_Draw ("draw prop(s,y,size,alpha)",Vector) = (0,0,0,0)
		_Prev ("prev pos", Vector) = (0,0,0,0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		sampler2D _MainTex,_ShapeTex;
		float4 _Draw,_Prev;
		half4 _MainTex_TexelSize;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half2
				prePos = _Prev.xy,
				pos = _Draw.xy,
				size = _MainTex_TexelSize.xy * _Draw.z;
			float2
				uv = IN.uv_MainTex,
				uv2 = (uv - (prePos - size * 0.5))/size,
				uv3 = (uv - (pos - size * 0.5))/size;
			half intencity = _Draw.a;
			
			half4
				base = tex2D(_MainTex, uv),
				draw = tex2D(_ShapeTex, uv2);
			for(float f = 0.1; f < 1; f += 0.1)
				draw += tex2D(_ShapeTex, lerp(uv2,uv3,f));
			draw.a *= intencity/10;
			
			o.Emission = lerp(base, draw, saturate(draw.a));
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
