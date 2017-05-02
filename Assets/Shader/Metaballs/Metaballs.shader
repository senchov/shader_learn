Shader "L_SHADERS/Metaballs"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			//#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				//UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}

			float random (float val) 
			{
				return frac (sin (val * 13.0) *43000);
			}

			float random (float2 st) 
			{
				return frac (sin (dot (st.xy, float2 (13.0, 78.23) ) ) *43000);
			}

			float2 random2 (float val) 
			{
				float2 st = float2 ( dot(float2(val,val) , float2 (127,311)) , dot (float2(val,val), float2 (269.5, 183.3)) );
				return -1 + 2.0 * frac (sin(st) * 50000);
			}

			float2 random2 (float2 st) 
			{
				st = float2 ( dot(st, float2 (127,311)) , dot (st, float2 (269.5, 183.3)) );
				return -1 + 2.0 * frac (sin(st) * 50000);
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				float3 col = float3 (0,0,0);
				float d = min (_ScreenParams.x, _ScreenParams.y);
				float2 st = (i.vertex.xy - (_ScreenParams.xy /2)) / d;
				float t = _Time.y;

				float3 m_dist = float3 (0,0,0);
				for (int i =0; i <10; i++) 
				{
					float2 pos = random2 (float2 (float(i) , 0.2)) * 0.2;
					float angle = lerp (0, 6.28, random (float(i)));
					float radius = lerp (0.01, 0.2, random (float(i)));
					float freq = 1.0;
					if (random (float(i)) > 0.5)
					{
						freq = -1;
					}
					float2 offset1 = radius * float2 (sin (freq*t +angle) , cos (freq*t +angle));
					m_dist.x += 1.0 / distance (st + float2 (0,0) , pos + offset1);
					//m_dist.y += 1.0 / distance (st + float2 (0.01,0.01) , pos + offset1);
					//m_dist.x += 1.0 / distance (st + float2 (0.05,0) , pos + offset1);
				}

				//m_dist.x -= 2.0 / distance (st + float2 (0,0) , p);
				//m_dist.g -= 2.0 / distance (st + float2 (0.01,0.01) , p);
				//m_dist.x -= 2.0 / distance (st + float2 (0.05,0) , p);

				col += smoothstep (0.49 , 0.5, m_dist * 0.01);

				return float4 (col.x,col.y,col.z, 1.0);
			}
			ENDCG
		}
	}
}
