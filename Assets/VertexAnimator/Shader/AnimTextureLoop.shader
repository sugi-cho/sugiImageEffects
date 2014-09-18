Shader "VertexAnim/loop" {
Properties {
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_AnimTex ("PosTex", 2D) = "white" {}
	_Scale ("scale", Vector) = (1,1,1,1)
	_Delta ("Delta", Vector) = (0,0,0,0)
	_AnimEnd ("End Time", float) = 30
	_Speed ("Animation Speed(fps)", float) = 10
	_T ("Time", float) = 0
}
SubShader { 
	Tags { "RenderType"="Opaque" }
	LOD 700
	Cull Off
	Stencil {
		Ref 2
		Comp always
		PassFront replace
		PassBack replace
	}
	
CGPROGRAM
#pragma surface surf Lambert addshadow vertex:disp noforwardadd
#pragma target 5.0
#pragma target 3.0
#pragma glsl

struct appdata {
	float4 vertex : POSITION;
	float4 tangent : TANGENT;
	float3 normal : NORMAL;
	float2 texcoord : TEXCOORD0;
	float4 texcoord1 : TEXCOORD1;
};

sampler2D _AnimTex;
float4 _Scale;
float4 _Delta;
float _AnimEnd;
float _Speed;
float _T;

half4 _AnimTex_TexelSize;

void disp (inout appdata v)
{
	//float t = min(_AnimEnd*30/_Speed, _T);
	float t = fmod(_Time.y - _T,_AnimEnd*30/_Speed);
	v.texcoord1.y += _Speed*t*_AnimTex_TexelSize.y;
	float3 pos1 = tex2Dlod(_AnimTex, v.texcoord1).rgb;
	v.texcoord1.y += 0.5;
	float3 pos2 = tex2Dlod(_AnimTex, v.texcoord1).rgb;
	float3 pos = float3(
		(pos1.r + pos1.g/256.0)*_Scale.x+_Delta.x,
		(pos1.b + pos2.r/256.0)*_Scale.y+_Delta.y,
		(pos2.g + pos2.b/256.0)*_Scale.z+_Delta.z
	);
	v.vertex.xyz += pos;
}

sampler2D _MainTex;

struct Input {
	float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	o.Emission = tex;
	o.Alpha = 1;
}
ENDCG
}

FallBack "Diffuse"
}
