Shader "Unlit/WindFlagShaderWithSpecular"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {} // Textura principal de la bandera
        _WaveSpeed("Wave Speed", Float) = 1.0 // Velocidad de la onda del viento
        _WaveIntensity("Wave Intensity", Float) = 0.1 // Intensidad de la onda del viento
        _WindDirection("Wind Direction", Vector) = (1,0,0) // Dirección del viento
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1) // Color de la luz especular
        _Shininess ("Shininess", Range(1, 128)) = 32 // Brillo especular
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf BlinnPhongSpecular vertex:vert addshadow
        
        struct Input
        {
            float2 uv_MainTex;
        };
        
        sampler2D _MainTex;
        float _WaveSpeed;
        float _WaveIntensity;
        float3 _WindDirection;
        float _Shininess;

        void vert(inout appdata_full v, out Input o)
        {
            float time = _Time.y * _WaveSpeed;
            float wave = sin(dot(v.vertex.xyz, _WindDirection) * _WaveIntensity + time);
            v.vertex.y += wave;
            o.uv_MainTex = v.texcoord.xy;
        }
        
        half4 LightingBlinnPhongSpecular(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            // Diffuse term
            half3 h = normalize(lightDir + viewDir);
            half diff = max(0, dot(s.Normal, lightDir));
            
            // Specular term
            half spec = pow(max(0, dot(s.Normal, h)), _Shininess);
            
            half4 c;
            c.rgb = _LightColor0.rgb * (s.Albedo * diff + _SpecColor.rgb * spec * atten);
            c.a = s.Alpha;
            return c;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = texColor.rgb;
            o.Alpha = texColor.a;
            o.Specular = _SpecColor.rgb;
            o.Gloss = _Shininess;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

