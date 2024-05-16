Shader "Unlit/WindFlagShaderWithLambertAndAmbient"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {} // Textura principal de la bandera
        _WaveSpeed("Wave Speed", Float) = 1.0 // Velocidad de la onda del viento
        _WaveIntensity("Wave Intensity", Float) = 0.1 // Intensidad de la onda del viento
        _WindDirection("Wind Direction", Vector) = (1,0,0) // Dirección del viento
        _AmbientColor ("Ambient Color", Color) = (0.2, 0.2, 0.2, 1) // Color de la luz ambiental
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert addshadow
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        sampler2D _MainTex;
        float _WaveSpeed;
        float _WaveIntensity;
        float3 _WindDirection;
        fixed4 _AmbientColor;

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

            // Iluminación Lambertiana
            o.Normal = normalize(o.Normal);
            half NdotL = dot(o.Normal, _WorldSpaceLightPos0.xyz);
            o.Emission = _AmbientColor.rgb + texColor.rgb * NdotL;

            o.Alpha = texColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

