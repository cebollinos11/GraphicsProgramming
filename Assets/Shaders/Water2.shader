﻿Shader "Pablo/Water/Full" {
	Properties{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_WaterLevel("Water Level",Range(0.0,1.0)) = 0.5
		

	}
	SubShader
		{
			Tags{
				
				"Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
				"PreviewType" = "Plane"
				"CanUseSpriteAtlas" = "True"
			}

			
			Cull Off
			Lighting Off
			ZWrite Off
			Fog{ Mode Off }
			Blend One OneMinusSrcAlpha
			Pass
				{
					CGPROGRAM
#pragma vertex vert             
#pragma fragment frag             
//#pragma multi_compile DUMMY PIXELSNAP_ON             
#include "UnityCG.cginc"             
					struct appdata_t
					{
						float4 vertex   : POSITION;
						float4 color    : COLOR;
						float2 texcoord : TEXCOORD0;
					};

					struct v2f
					{
						float4 vertex   : SV_POSITION;
						fixed4 color : COLOR;
						half2 texcoord  : TEXCOORD0;
					};

					float _WaterLevel;
					
					
					v2f vert(appdata_t IN) 
					{
						v2f OUT;


						OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex*float4(1.0, 2.0, 1.0, 1.0) );
						
						OUT.texcoord = IN.texcoord;
						OUT.color = IN.color ;
/*
#ifdef PIXELSNAP_ON                 
						OUT.vertex = UnityPixelSnap(OUT.vertex);
#endif
						'*/
						return OUT;
					}

					sampler2D _MainTex;
					fixed4 frag(v2f IN) : SV_Target
					{
						half d = 2.0;
						
						fixed4 c = tex2D(_MainTex, IN.texcoord/half2(1.0,1/d) - half2(0.0,1.0)) * IN.color;

						
						
						if (IN.texcoord.y <= _WaterLevel)
						{

							//water movement
							float diff = sin(_Time.x * 90 + IN.texcoord.y*IN.texcoord.y*180)*0.03;
							c = tex2D(_MainTex, float2(IN.texcoord.x+diff, 1.0 - IN.texcoord.y*d)) * IN.color;

							//water tint
							c.b = 1.0;
							
						}
						
						 /*
						if (IN.texcoord.y  < 0.5)
						{
							c = 1.0;
						}*/
						
						c.rgb *= c.a;
						return c;
					}
						ENDCG

				}
		}
}