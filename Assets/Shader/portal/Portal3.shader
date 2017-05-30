// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// unlit, vertex color, 2 textures, alpha blended
// cull off

Shader "L_SHADERS/Portals_3" 
{
	Properties 
	{
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_GradientTex ("Gradient (RGBA)", 2D) = "white" {}
		_BorderLevel("BorderLevel", Float) = 1
	}

	SubShader
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		ZWrite Off Lighting Off Cull Off Fog { Mode Off } Blend SrcAlpha OneMinusSrcAlpha
		LOD 110
		
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert_vctt
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			sampler2D _GradientTex;
			float _BorderLevel;

			struct vin_vctt
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};

			struct v2f_vctt
			{
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float4 texcoord01 : TEXCOORD0;
			};

			v2f_vctt vert_vctt(vin_vctt v)
			{
				v2f_vctt o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord01.xy = v.texcoord;
				o.texcoord01.zw = v.texcoord;
				return o;
			}

			fixed4 frag(v2f_vctt i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord01.xy) * i.color;
				fixed4 borderCol =  tex2D(_GradientTex, i.texcoord01.zw);
//				if (i.texcoord01.x > _BorderLevel && i.texcoord01.y > _BorderLevel)
//					col = tex2D(_GradientTex, i.texcoord01.zw);
				return col * borderCol;
			}
			
			ENDCG
		} 
	}
}
