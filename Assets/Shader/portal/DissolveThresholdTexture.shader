// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "tk2d/DissolveThresholdTexture"
{
	Properties
	{
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_AlphaCh ("Alpha channel (R)", 2D) = "white" {}
		_DissolveTex("Dissolve texture", 2D) = "white" {}
		_CutoutLevel("Cutout Level", Float) = 0
		_AdditionalTexture("Close texture", 2D) = "white" {}
		_SolidColorLevel("Level for solid close texture", Float) = 0
		_LerpColorLevel("Level for lerp close texture", Float) = 0
		[KeywordEnum(On, Off)] _Etc("ETC Mode", Float) = 0

	}

	SubShader
		{
			Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			ZWrite Off Lighting Off Cull Off Fog{ Mode Off } Blend SrcAlpha OneMinusSrcAlpha
			LOD 110

			Pass
			{
				CGPROGRAM
#pragma vertex vert_vct
#pragma fragment frag_mult 
#pragma fragmentoption ARB_precision_hint_fastest
#include "UnityCG.cginc"
#pragma multi_compile _ETC_ON _ETC_OFF

				sampler2D _MainTex;
				sampler2D _AlphaCh;
				sampler2D _DissolveTex;
				float _CutoutLevel;
				sampler2D _AdditionalTexture;
				float _SolidColorLevel;
				float _LerpColorLevel;

				float4 _MainTex_ST;

				struct vin_vct
				{
					float4 vertex : POSITION;
					float4 color : COLOR;
					float2 texcoord : TEXCOORD0;
					float2 texcoord2 : TEXCOORD1;
				};

				struct v2f_vct
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
					float2 texcoord2 : TEXCOORD1;
				};

				v2f_vct vert_vct(vin_vct v)
				{
					v2f_vct o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.color = v.color;
					o.texcoord = v.texcoord;
					o.texcoord2 = v.texcoord2;
					return o;
				}

				fixed4 frag_mult(v2f_vct i) : SV_Target
				{
					fixed4 col = tex2D(_MainTex, i.texcoord) * i.color;
#ifdef _ETC_ON
					fixed4 AlphaCh = tex2D(_AlphaCh,(i.texcoord))* i.color.a;
					col = fixed4(col.x, col.y, col.z, AlphaCh.x);
#endif
					if(col.a == 0)
                        return col;

					fixed level = tex2D(_DissolveTex, i.texcoord2).r;
					fixed4 alterColor = tex2D(_AdditionalTexture, i.texcoord2);
					level -= _CutoutLevel;

					float lerpFactor = (level - _SolidColorLevel) / _LerpColorLevel;
					col = lerp(alterColor, col, clamp(lerpFactor, 0, 1));

					if (level < 0)
						col.a = 0;

					return col;
				}

					ENDCG
			}
		}
}