Shader "UI/UI-Effect-Dissolve"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

		[Header(Dissolve)]
		_NoiseTex("Noise Texture (A)", 2D) = "white" {}
		_DissolveRange("DissolveRange",Range(0,1.0)) = 0.5
		_DissolveWidth("DissolveWidth",Range(0,1.0)) = 0.5
		_DissolveSoftness("DissolveSoftness",Range(0,1.0)) = 0.5
		_DissolveColor ("DissolveColor", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask [_ColorMask]

        Pass
        {
            Name "Default"
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile __ UNITY_UI_CLIP_RECT
            #pragma multi_compile __ UNITY_UI_ALPHACLIP

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID

				float2 uv1 : TEXCOORD1;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO

				float4 srcPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            float4 _MainTex_ST;
			sampler2D _NoiseTex;
			float4 _NoiseTex_ST;
			float _DissolveRange;
			float _DissolveWidth;
			float _DissolveSoftness;
			fixed4 _DissolveColor;

            v2f vert(appdata_t v)
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
                OUT.worldPosition = v.vertex;
                OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);
				OUT.srcPos=ComputeScreenPos(OUT.vertex);

                OUT.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;

				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif

				float2 noiseUV=float2(IN.srcPos.xy*_NoiseTex_ST+_NoiseTex_ST.zw);
				float cutout = tex2D(_NoiseTex, noiseUV).a;
				_DissolveWidth=_DissolveWidth/4;
                float factor = cutout - _DissolveRange * ( 1 + _DissolveWidth ) + _DissolveWidth;

                #ifdef UNITY_UI_ALPHACLIP
                clip (min(color.a - 0.01, factor));
                #endif

				fixed edgeLerp = step(factor, color.a) * saturate((_DissolveWidth - factor)*16/ _DissolveSoftness);
				half4 temp = fixed4(_DissolveColor.rgb, edgeLerp);
				color.rgb += temp.rgb * temp.a;
				color.a *= saturate((factor)*32/ _DissolveSoftness);

				return color;
            }
        ENDCG
        }
    }
}