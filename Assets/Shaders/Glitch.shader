Shader "Pablo/Glitch" {
	Properties{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_NoiseTexture("Noise Texture", 2D) = "white" {}
		_RadarTexture("Noise Texture", 2D) = "white" {}
		

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

					
					
					
					v2f vert(appdata_t IN)
					{
						v2f OUT;

						
						
						
						OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
						
						
						
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
					sampler2D _NoiseTexture;
					sampler2D _RadarTexture;
					fixed4 frag(v2f IN) : SV_Target
					{

						float v = sin(_Time.y*1.1)/4+0.5;
						half tint = 0;
						
						if (IN.texcoord.x > v-0.1 && IN.texcoord.x < v+ 0.1)
						{
							if (sin(_Time.w * 2) > 0.8)
							{
								IN.texcoord.y = IN.texcoord.y - 0.06;//sin(_Time.w*5) / 15;
								
								tint = 1.0;

							}
								
						}

						fixed4 c = tex2D(_MainTex, IN.texcoord) * IN.color;

						if (tint){
							c.a *= 0.7;
						}
						
						c.rgb *= c.a;
						
						if (c.a > 0.99)
						{
							//IN.texcoord *= 0.0;

							


							fixed4 noise = tex2D(_NoiseTexture, IN.texcoord + half2(0,_Time.y) );
							c.rgb = lerp(c.rgb, noise.rgb, 0.2);
							//c.rgb = lerp(c.rgb, fixed3(c.r, 1.0, c.b), 0.2);
							

							fixed4 radar = tex2D(_RadarTexture, IN.texcoord + half2(0, _Time.y));
							if (radar.a > 0.1)
							{
								c.rgb = lerp(c.rgb, radar.rgb, 0.2);
								//c.rgb = fixed3(1, 1, 1) - c.rgb;
								//c.a = 0.1;
								/*c.r = 1 - c.r;
								c.g = 1.0 - c.g;
								c.b = 1.0 - c.b;
								*/
							}
							//c.rgb = lerp(c.rgb, fixed3(0.0,0.0,1.0), 0.1);
						}

						return c;
					}
						ENDCG

				}
		}
}