Shader "Custom/MyShaderSurfaceShader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
        _BumpMap("Bumpmap", 2D) = "bump" {}
        _EmissiveTex("Emissive (RGB)", 2D) = "white" {}
        _EmissiveColor("Emissive Color", Color) = (1,1,1,1)
        _EmissivePower("Emissive Power", Range(0.1,10.0)) = 1.0
        _OcclusionMap("Ambient Occlusion (G)", 2D) = "white" {}
        _OcclusionStrength("Occlusion Strength", Range(0, 1)) = 1.0
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma surface surf Standard fullforwardshadows

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0

            sampler2D _MainTex;
            sampler2D _BumpMap;
            sampler2D _EmissiveTex;
            sampler2D _OcclusionMap;

            struct Input
            {
                float2 uv_MainTex;
                float2 uv_BumpMap;
                float2 uv_OcclusionMap;
            };

            half _Glossiness;
            half _Metallic;
            fixed4 _Color;
            fixed4 _EmissiveColor;
            float _EmissivePower;
            float _OcclusionStrength;

            // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
            // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
            // #pragma instancing_options assumeuniformscaling
            UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props)

            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                // Albedo comes from a texture tinted by color
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
                fixed4 emissiveText = tex2D(_EmissiveTex, IN.uv_MainTex) * _EmissiveColor;
                o.Albedo = c.rgb ;
                // Apply ambient occlusion
                fixed4 occlusion = tex2D(_OcclusionMap, IN.uv_OcclusionMap);

                if (length(occlusion.rgb) > 0)
                {
                    o.Albedo *= occlusion.rgb* _OcclusionStrength;
                }

                // If the emissive texture has significant color, multiply it with the albedo
                if (length(emissiveText.rgb) > 0)
                {
                    o.Albedo *= emissiveText.rgb * _EmissivePower;
                }

                o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
                // Metallic and smoothness come from slider variables
                o.Metallic = _Metallic;
                o.Smoothness = _Glossiness;
                o.Alpha = c.a;
            }
            ENDCG
        }
            FallBack "Diffuse"
}
