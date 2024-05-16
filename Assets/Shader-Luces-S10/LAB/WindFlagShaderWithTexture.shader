Shader "Custom/WindFlagShaderWithTexture"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {} // Textura principal de la bandera
        _WaveSpeed("Wave Speed", Float) = 1.0 // Velocidad de la onda del viento
        _WaveIntensity("Wave Intensity", Float) = 0.1 // Intensidad de la onda del viento
        _WindDirection("Wind Direction", Vector) = (1,0,0) // Dirección del viento
        _Color("Diffuse Material Color", Color) = (1, 1, 1, 1) // Color difuso
        _SpecColor("Specular Material Color", Color) = (1, 1, 1, 1) // Color especular
        _Shininess("Shininess", Float) = 10 // Brillo
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            Pass
            {
                Tags { "LightMode" = "ForwardBase" } // Pass para luz ambiental y primera fuente de luz

                CGPROGRAM

                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"
                uniform float4 _LightColor0; // Color de la fuente de luz (de "Lighting.cginc")
                uniform sampler2D _MainTex; // Textura principal

                // Propiedades especificadas por el usuario
                uniform float4 _Color;
                uniform float4 _SpecColor;
                uniform float _Shininess;
                uniform float _WaveSpeed;
                uniform float _WaveIntensity;
                uniform float3 _WindDirection;

                struct vertexInput
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0;
                };
                struct vertexOutput
                {
                    float4 pos : SV_POSITION;
                    float4 col : COLOR;
                    float2 uv : TEXCOORD0;
                };

                vertexOutput vert(vertexInput input)
                {
                    vertexOutput output;

                    // Movimiento de la bandera con el viento
                    float time = _Time.y * _WaveSpeed;
                    float wave = sin(dot(input.vertex.xyz, _WindDirection) * _WaveIntensity + time);
                    input.vertex.y += wave;

                    float4x4 modelMatrix = unity_ObjectToWorld;
                    float3x3 modelMatrixInverse = unity_WorldToObject;
                    float3 normalDirection = normalize(mul(input.normal, modelMatrixInverse));
                    float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(modelMatrix, input.vertex).xyz);
                    float3 lightDirection;
                    float attenuation;

                    if (0.0 == _WorldSpaceLightPos0.w) // ¿Luz direccional?
                    {
                        attenuation = 1.0; // sin atenuación
                        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                    }
                    else // Luz puntual o de foco
                    {
                        float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(modelMatrix, input.vertex).xyz;
                        float distance = length(vertexToLightSource);
                        attenuation = 1.0 / distance; // Atenuación lineal
                        lightDirection = normalize(vertexToLightSource);
                    }

                    float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;

                    float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));

                    float3 specularReflection;
                    if (dot(normalDirection, lightDirection) < 0.0) // ¿Fuente de luz en el lado incorrecto?
                    {
                        specularReflection = float3(0.0, 0.0, 0.0); // Sin reflexión especular
                    }
                    else // Fuente de luz en el lado correcto
                    {
                        specularReflection = attenuation * _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
                    }

                    output.col = float4(ambientLighting + diffuseReflection + specularReflection, 1.0);
                    output.pos = UnityObjectToClipPos(input.vertex);
                    output.uv = input.uv; // Pasar las coordenadas de textura
                    return output;
                }

                float4 frag(vertexOutput input) : COLOR
                {
                    float4 texColor = tex2D(_MainTex, input.uv);
                    return input.col * texColor;
                }

                ENDCG
            }

            Pass
            {
                Tags { "LightMode" = "ForwardAdd" } // Pass para fuentes de luz adicionales
                Blend One One // Mezcla aditiva

                CGPROGRAM

                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"
                uniform float4 _LightColor0; // Color de la fuente de luz (de "Lighting.cginc")
                uniform sampler2D _MainTex; // Textura principal

                // Propiedades especificadas por el usuario
                uniform float4 _Color;
                uniform float4 _SpecColor;
                uniform float _Shininess;
                uniform float _WaveSpeed;
                uniform float _WaveIntensity;
                uniform float3 _WindDirection;

                struct vertexInput
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0;
                };
                struct vertexOutput
                {
                    float4 pos : SV_POSITION;
                    float4 col : COLOR;
                    float2 uv : TEXCOORD0;
                };

                vertexOutput vert(vertexInput input)
                {
                    vertexOutput output;

                    // Movimiento de la bandera con el viento
                    float time = _Time.y * _WaveSpeed;
                    float wave = sin(dot(input.vertex.xyz, _WindDirection) * _WaveIntensity + time);
                    input.vertex.y += wave;

                    float4x4 modelMatrix = unity_ObjectToWorld;
                    float3x3 modelMatrixInverse = unity_WorldToObject;
                    float3 normalDirection = normalize(mul(input.normal, modelMatrixInverse));
                    float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(modelMatrix, input.vertex).xyz);
                    float3 lightDirection;
                    float attenuation;

                    if (0.0 == _WorldSpaceLightPos0.w) // ¿Luz direccional?
                    {
                        attenuation = 1.0; // sin atenuación
                        lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                    }
                    else // Luz puntual o de foco
                    {
                        float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(modelMatrix, input.vertex).xyz;
                        float distance = length(vertexToLightSource);
                        attenuation = 1.0 / distance; // Atenuación lineal
                        lightDirection = normalize(vertexToLightSource);
                    }

                    float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));

                    float3 specularReflection;
                    if (dot(normalDirection, lightDirection) < 0.0) // ¿Fuente de luz en el lado incorrecto?
                    {
                        specularReflection = float3(0.0, 0.0, 0.0); // Sin reflexión especular
                    }
                    else // Fuente de luz en el lado correcto
                    {
                        specularReflection = attenuation * _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
                    }

                    output.col = float4(diffuseReflection + specularReflection, 1.0); // Sin contribución ambiental en este pass
                    output.pos = UnityObjectToClipPos(input.vertex);
                    output.uv = input.uv; // Pasar las coordenadas de textura
                    return output;
                }

                float4 frag(vertexOutput input) : COLOR
                {
                    float4 texColor = tex2D(_MainTex, input.uv);
                    return input.col * texColor;
                }

                ENDCG
            }
        }
            Fallback "Specular"
}

