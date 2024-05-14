Shader "Custom/WindFlagShader"
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
        
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        sampler2D _MainTex;
        float _WaveSpeed;
        float _WaveIntensity;
        float3 _WindDirection;
        
        void vert(inout appdata_full v, out Input o)
        {
            float time = _Time.y * _WaveSpeed;
            float wave = sin(dot(v.vertex.xyz, _WindDirection) * _WaveIntensity + time);
            v.vertex.y += wave;
            o.uv_MainTex = v.texcoord.xy;
        }
        
        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = texColor.rgb;
            o.Alpha = texColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
