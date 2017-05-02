// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "L_SHADERS/Basic" {
	Properties 
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SecondTex ("SecondTexture", 2D) = "white" {}
		_DisplaceTex ("DisplacementTexture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_Tween ("Tween", Range(0,1)) = 0.0
		_Magnitude ("Magnitude", Range (0, 0.1)) = 0
	}

	SubShader 
	{	
		Tags { "RenderType"="Transperent"}

				
		Pass 
		{
			Blend SrcAlpha OneMinusSrcAlpha
			//Blend One One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata 
			{
				float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos (v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			sampler2D _SecondTex;
			sampler2D _DisplaceTex;
			fixed4 _Color;
			float _Tween;
			float _Magnitude;
			float _OutMagnitude;

			float4 frag (v2f i) : SV_Target
			{
				float4 color1 = tex2D (_MainTex, i.uv);
				float4 color2 = tex2D (_SecondTex, i.uv);


				float4 color = tex2D (_MainTex, i.uv);
				float lum = color.r * 0.3 + color.g * 0.59 + color.b * 0.11;
				float4 grayscale = float4 (lum,lum,lum, color.a);

				float2 disp =  tex2D (_DisplaceTex, i.uv).xy;
				disp = ((disp * 2) - 1)  * sin (_Time.x) * 0.1; //_Magnitude;

				float4 col =  tex2D (_MainTex, i.uv + disp);

				   
				return col;
			}
			ENDCG			
		}
	}
}
