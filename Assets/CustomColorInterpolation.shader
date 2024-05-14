Shader "Custom/ColorInterpolation"
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
        
        CGPROGRAM
        #pragma surface surf Lambert
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        sampler2D _MainTex;
        fixed4 _ColorA;
        fixed4 _ColorB;
        float _Interpolation;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = lerp(_ColorA.rgb, _ColorB.rgb, _Interpolation);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
