Shader "Custom/MultiplyTextures"
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
        
        CGPROGRAM
        #pragma surface surf Lambert
        
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SecondaryTex;
        };
        
        sampler2D _MainTex;
        sampler2D _SecondaryTex;
        
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 texColorA = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 texColorB = tex2D(_SecondaryTex, IN.uv_SecondaryTex);
            o.Albedo = texColorA.rgb * texColorB.rgb; 
            o.Alpha = texColorA.a * texColorB.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
