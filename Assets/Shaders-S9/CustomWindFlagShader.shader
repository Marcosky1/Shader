Shader "Unlit/WindFlagShader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {} // Textura principal de la bandera
        _WaveSpeed("Wave Speed", Float) = 1.0 // Velocidad de la onda del viento
        _WaveIntensity("Wave Intensity", Float) = 0.1 // Intensidad de la onda del viento
        _WindDirection("Wind Direction", Vector) = (1,0,0) // Dirección del viento
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
            };
            
            struct v2f
            {
                float2 uv_MainTex : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            
            sampler2D _MainTex;
            float _WaveSpeed;
            float _WaveIntensity;
            float3 _WindDirection;
            
            v2f vert(appdata v)
            {
                v2f o;
                float time = _Time.y * _WaveSpeed;
                float wave = sin(dot(v.vertex.xyz, _WindDirection) * _WaveIntensity + time);
                v.vertex.y += wave;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv_MainTex = v.uv_MainTex;
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTex, i.uv_MainTex);
                return texColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

