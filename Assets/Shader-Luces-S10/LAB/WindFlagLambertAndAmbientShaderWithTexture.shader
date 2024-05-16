Shader "Custom/WindFlagLambertAndAmbientShaderWithTexture"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {} // Textura principal del material
        _Color("Color", Color) = (1, 1, 1, 1) // Color del material
        _WaveSpeed("Wave Speed", Float) = 1.0 // Velocidad de la onda del viento
        _WaveIntensity("Wave Intensity", Float) = 0.1 // Intensidad de la onda del viento
        _WindDirection("Wind Direction", Vector) = (1, 0, 0) // Dirección del viento
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 100

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile_fog

                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float3 worldNormal : TEXCOORD0;
                    float2 uv : TEXCOORD1;
                    float4 vertex : SV_POSITION;
                    UNITY_FOG_COORDS(1)
                };

                sampler2D _MainTex;
                float4 _Color;
                float _WaveSpeed;
                float _WaveIntensity;
                float3 _WindDirection;

                v2f vert(appdata v)
                {
                    v2f o;

                    // Movimiento de la bandera con el viento
                    float time = _Time.y * _WaveSpeed;
                    float wave = sin(dot(v.vertex.xyz, _WindDirection) * _WaveIntensity + time);
                    v.vertex.y += wave;

                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.worldNormal = UnityObjectToWorldNormal(v.normal);
                    o.uv = v.uv;
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    float3 normal = normalize(i.worldNormal);

                    float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                    float diff = max(0, dot(normal, lightDir));

                    float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                    fixed4 texColor = tex2D(_MainTex, i.uv);
                    float4 col = texColor * _Color * diff + float4(ambient, 1.0);

                    UNITY_APPLY_FOG(i.fogCoord, col);

                    return col;
                }
                ENDCG
            }
        }
            FallBack "Diffuse"
}
