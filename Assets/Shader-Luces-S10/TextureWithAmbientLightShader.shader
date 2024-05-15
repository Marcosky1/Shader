Shader "Unlit/TextureWithAmbientLightShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {} // Textura principal
        _AmbientColor("Ambient Color", Color) = (1, 1, 1, 1) // Color de la luz ambiental
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
                // make fog work
                #pragma multi_compile_fog

                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                    UNITY_FOG_COORDS(1)
                };

                sampler2D _MainTex;
                float4 _AmbientColor;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = v.uv;
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // Sample the texture
                    fixed4 texColor = tex2D(_MainTex, i.uv);

                // Apply ambient light
                fixed4 col = texColor * _AmbientColor;

                // Apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                return col;
            }
            ENDCG
        }
        }
}
