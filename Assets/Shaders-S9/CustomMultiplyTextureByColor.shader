Shader "Custom/MultiplyTextureByColor"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {} // Textura principal
        _Color("Color", Color) = (1, 1, 1, 1) // Color a multiplicar
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf Lambert
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        sampler2D _MainTex;
        fixed4 _Color;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = texColor.rgb * _Color.rgb; 
            o.Alpha = texColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
