Shader "Unlit/MultiplyTexturesShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {} // Primera textura
        _SecondaryTex("Secondary Texture", 2D) = "white" {} // Segunda textura
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv_MainTex : TEXCOORD0;
                float2 uv_SecondaryTex : TEXCOORD1;
            };
            
            struct v2f
            {
                float2 uv_MainTex : TEXCOORD0;
                float2 uv_SecondaryTex : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };
            
            sampler2D _MainTex;
            sampler2D _SecondaryTex;
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv_MainTex = v.uv_MainTex;
                o.uv_SecondaryTex = v.uv_SecondaryTex;
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 texColorA = tex2D(_MainTex, i.uv_MainTex);
                fixed4 texColorB = tex2D(_SecondaryTex, i.uv_SecondaryTex);
                return texColorA * texColorB;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

