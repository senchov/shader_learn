// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/waterShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Scale ("Scale",float)  = 1
		_Speed ("Speed",float)  = 1
		_Frequency ("Frequency",float)  = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows  
		#pragma vertex vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		float _Scale,_Speed,_Frequency;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		half4 _Color;
		float _WaweAmplitude8, _WaweAmplitude1, _WaweAmplitude2, _WaweAmplitude3, _WaweAmplitude4,
				_WaweAmplitude5, _WaweAmplitude6, _WaweAmplitude7;
		float _Offsetx8, _Offsetz8, _Offsetx1, _Offsetz1, _Offsetx2, _Offsetz2, _Offsetx3, _Offsetz3,
				_Offsetx4, _Offsetz4, _Offsetx5, _Offsetz5, _Offsetx6, _Offsetz6, _Offsetx7, _Offsetz7;
		float _Distance1,_Distance2,_Distance3,_Distance4,_Distance5,_Distance6,_Distance7,_Distance8;
		float _xImpact1, _zImpact1, _xImpact2, _zImpact2, _xImpact3, _zImpact3, _xImpact4, _zImpact4,
			_xImpact5, _zImpact5, _xImpact6, _zImpact6, _xImpact7, _zImpact7,_xImpact8, _zImpact8;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void vert (inout appdata_full v) 
		{
			half offsetvert = (v.vertex.x *v.vertex.x)+ (v.vertex.z * v.vertex.z);

			half value8 = _Scale * sin (_Time.w * _Speed * _Frequency + offsetvert + (v.vertex.x * _Offsetx8) 
				+ (v.vertex.z + _Offsetz8) );

			half value1 = _Scale * sin (_Time.w * _Speed * _Frequency + offsetvert + (v.vertex.x * _Offsetx1) 
				+ (v.vertex.z + _Offsetz1) );
			half value2 = _Scale * sin (_Time.w * _Speed * _Frequency + offsetvert + (v.vertex.x * _Offsetx2) 
				+ (v.vertex.z + _Offsetz2) );
			half value3 = _Scale * sin (_Time.w * _Speed * _Frequency + offsetvert + (v.vertex.x * _Offsetx3) 
				+ (v.vertex.z + _Offsetz3) );
			half value4 = _Scale * sin (_Time.w * _Speed * _Frequency + offsetvert + (v.vertex.x * _Offsetx4) 
				+ (v.vertex.z + _Offsetz4) );
			half value5 = _Scale * sin (_Time.w * _Speed * _Frequency + offsetvert + (v.vertex.x * _Offsetx5) 
				+ (v.vertex.z + _Offsetz5) );
			half value6 = _Scale * sin (_Time.w * _Speed * _Frequency + offsetvert + (v.vertex.x * _Offsetx6) 
				+ (v.vertex.z + _Offsetz6) );
			half value7 = _Scale * sin (_Time.w * _Speed * _Frequency + offsetvert + (v.vertex.x * _Offsetx7) 
				+ (v.vertex.z + _Offsetz7) );


			float3 worldPos = mul (unity_ObjectToWorld, v.vertex).xyz;

			if (sqrt (pow (worldPos.x - _xImpact8,2) + pow (worldPos.z - _zImpact8,2)) < _Distance8)
			{
				v.vertex.y += value8 * _WaweAmplitude8;
				v.normal.y += value8 * _WaweAmplitude8;
			}

			if (sqrt (pow (worldPos.x - _xImpact1,2) + pow (worldPos.z - _zImpact1,2)) < _Distance1)
			{
				v.vertex.y += value1 * _WaweAmplitude1;
				v.normal.y += value1 * _WaweAmplitude1;
			}

			if (sqrt (pow (worldPos.x - _xImpact2,2) + pow (worldPos.z - _zImpact2,2)) < _Distance2)
			{
				v.vertex.y += value2 * _WaweAmplitude2;
				v.normal.y += value2 * _WaweAmplitude2;
			}

			if (sqrt (pow (worldPos.x - _xImpact3,2) + pow (worldPos.z - _zImpact3,2)) < _Distance3)
			{
				v.vertex.y += value3 * _WaweAmplitude3;
				v.normal.y += value3 * _WaweAmplitude3;
			}

			if (sqrt (pow (worldPos.x - _xImpact4,2) + pow (worldPos.z - _zImpact4,2)) < _Distance4)
			{
				v.vertex.y += value4 * _WaweAmplitude4;
				v.normal.y += value4 * _WaweAmplitude4;
			}

			if (sqrt (pow (worldPos.x - _xImpact5,2) + pow (worldPos.z - _zImpact5,2)) < _Distance5)
			{
				v.vertex.y += value5 * _WaweAmplitude5;
				v.normal.y += value5 * _WaweAmplitude5;
			}

			if (sqrt (pow (worldPos.x - _xImpact6,2) + pow (worldPos.z - _zImpact6,2)) < _Distance6)
			{
				v.vertex.y += value6 * _WaweAmplitude6;
				v.normal.y += value6 * _WaweAmplitude6;
			}

			if (sqrt (pow (worldPos.x - _xImpact1,2) + pow (worldPos.z - _zImpact1,2)) < _Distance1)
			{
				v.vertex.y += value7 * _WaweAmplitude7;
				v.normal.y += value7 * _WaweAmplitude7;
			}
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			//fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = _Color.rgb;
			// Metallic and smoothness come from slider variables
			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
			//o.Alpha = _Color.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
