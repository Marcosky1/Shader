Shader "Unlit/ColorInterpolationShader"
{
    Properties
    {
        _ColorA("Color A", Color) = (1, 0, 0, 1) 
        _ColorB("Color B", Color) = (0, 0, 1, 1) 
        _Interpolation("Interpolation", Range(0, 1)) = 0.5 // Valor de interpolación
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            
            float4 _ColorA;
            float4 _ColorB;
            float _Interpolation;
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target
            {
                return lerp(_ColorA, _ColorB, _Interpolation);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
