// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// unlit, vertex colour, alpha blended
// cull off

Shader "L_SHADERS/Portals" 
{
	Properties 
	{
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_FirstAlphaTexture ("FistAlphaTrxture", 2D) = "white" {}
		_SecondAlphaTexture ("FistAlphaTrxture", 2D) = "white" {}
		_Tween ("Tween", Range(0.15,1)) = 0.0
		_TexRange ("_TexRange", Range(-1,1)) = 0.0
	}
	
	SubShader
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		ZWrite Off Lighting Off Cull Off Fog { Mode Off } Blend SrcAlpha OneMinusSrcAlpha
		LOD 110
		
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert_vct
			#pragma fragment frag_mult 
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _FirstAlphaTexture;
			sampler2D _SecondAlphaTexture;
			float4 _MainTex_ST;
			float _Tween;
			float _TexRange;

			struct vin_vct 
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD1;
				float2 texcoord3 : TEXCOORD2;
			};

			struct v2f_vct
			{
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD1;
				float2 texcoord3 : TEXCOORD2;
			};

			v2f_vct vert_vct(vin_vct v)
			{
				v2f_vct o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = v.texcoord;
				o.texcoord2 = v.texcoord2;
				o.texcoord3 = v.texcoord3;
				o.texcoord2.x -= 0.5 - (_Tween * 0.5);
				o.texcoord2.y -= 0.5 - (_Tween * 0.5);
				return o;
			}

			fixed4 frag_mult(v2f_vct i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord) * i.color;

				float2 scaleTex = i.texcoord2  / _Tween;
				float4 alphaTex = tex2D(_FirstAlphaTexture, scaleTex);
				float4 alphaTex2 = tex2D(_SecondAlphaTexture, scaleTex);
				float alphatmp = alphaTex.r * alphaTex2.r ;

				alphatmp = clamp (alphatmp, 0 , 1);

				col = float4 (col.r, col.g, col.b, alphatmp);
				return col;
			}
			
			ENDCG
		} 
	}
}
