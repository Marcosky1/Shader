Shader "Unlit/LambertUnlitShader"
{
	Properties{
 _Color("Color", Color) = (1.0,1.0,1.0)
 _MainTex("Texture", 2D) = "white" {}
	}
		SubShader{
		Tags {"LightMode" = "ForwardBase"}
		Pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		// user defined variables
		uniform float4 _Color;
	// unity defined variables
	uniform float4 _LightColor0;
	sampler2D _MainTex;
	float4 _MainTex_ST;
	// base input structs
	struct vertexInput {
	float4 vertex: POSITION;
	float3 normal: NORMAL;
	float2 uv : TEXCOORD0;
	};
	struct vertexOutput {
	float4 pos: SV_POSITION;
	float4 col: COLOR;
	float2 uv : TEXCOORD0;
	};
	// vertex functions
	vertexOutput vert(vertexInput v) {
	vertexOutput o;
	float3 normalDirection = normalize(mul(float4(v.normal, 0.0),unity_WorldToObject).xyz);
	float3 lightDirection;
	float atten = 1.0;
	lightDirection = normalize(_WorldSpaceLightPos0.xyz);
	float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0,dot(normalDirection, lightDirection));
	// float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
	o.col = float4(diffuseReflection * _Color.rgb, 1.0);
	o.pos = UnityObjectToClipPos(v.vertex);
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	return o;
	}
	// fragment function
	float4 frag(vertexOutput i) : COLOR
	{
	fixed4 col = tex2D(_MainTex, i.uv);
	return i.col * col;
	}
	ENDCG
	}
		// fallback commentd out during development
		// fallback "Diffuse"
	}
}