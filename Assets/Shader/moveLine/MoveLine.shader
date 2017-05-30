// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// unlit, vertex colour, alpha blended
// cull off

Shader "Custom/ShineMoveLine" 
{
	Properties 
	{
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_LineColor ("Line color", Color) = (1,1,1,1)
		_LineWidth ("Line Width", Float) = 0
		_LineAngle ("Line angle", Float) = 0
		_LineMoveValue ("Line Move Value", Float) = 0
		_Shininess( "Shininess", Float ) = 10
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
			float4 _MainTex_ST;
			float4 _LineColor;
			float _LineWidth;
			float _LineAngle;
			float _LineMoveValue;
			float _Shininess;

			uniform fixed4 _LightColor0;

			struct vin_vct 
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 normal: NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f_vct
			{
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				fixed4 color1 : COLOR1;
				float2 texcoord : TEXCOORD0;
			};

			v2f_vct vert_vct(vin_vct v)
			{
				v2f_vct o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float3 lightDirection = WorldSpaceLightDir ( v.vertex );
				 lightDirection = normalize (lightDirection);
				 //float attenuation = 1.0;  / length( lightDirection );				

				o.texcoord = v.texcoord;
				float3 normalDir = normalize( mul( float4( v.normal, 1.0 ), unity_WorldToObject ).xyz );

				float3 viewDirection = WorldSpaceViewDir( v.vertex );


				float3 reflection = reflect( -lightDirection, normalDir );
				float4 rdotv = pow( max( 0.0, dot( reflection, viewDirection ) ), _Shininess );

				//with attenuation
				//specularReflection = attenuation *_LightColor0.rgb * _LineColor.rgb * rdotv;

				float3 specularReflection = _LightColor0.rgb * _LineColor.rgb * rdotv;
				o.color = v.color;
				o.color1 = float4 (specularReflection + v.color.xyz,1);
				return o;
			}

			fixed4 frag_mult(v2f_vct i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord) * i.color;
				float targetY = tan (_LineAngle) * i.texcoord.x;

				if (i.texcoord.y > targetY + _LineMoveValue && i.texcoord.y < targetY + _LineWidth + _LineMoveValue)
					col = tex2D(_MainTex, i.texcoord) * i.color1;
				return col ;//* _LineColor;
			}
			
			ENDCG
		} 
	}
}
