Shader "Pablo/Negative/NegativeRadious" {
	Properties{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_Radious("Radious", Range(0.0, 1.0)) = 0.0
		_OutlineThickness("Outline Thickness",Range(0.0,0.5)) = 0.0
		

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
					float _Radious;
					sampler2D _MainTex;
					float _OutlineThickness;
					fixed4 frag(v2f IN) : SV_Target
					{
						fixed4 c =  tex2D(_MainTex, IN.texcoord) * IN.color;

						fixed4 origc = c;

						if (_Radious >0.0 && distance(IN.texcoord, float2(0.5, 0.5)) < _Radious + _OutlineThickness)
						{
							c.rgb = 0.0f;
						}

						if (distance(IN.texcoord,float2(0.5,0.5)) < _Radious)
						{
							//origc = tex2D(_MainTex, IN.texcoord + float2(sin(_Time.x * 45 + IN.texcoord.y * 90), 0.0)*0.01)*IN.color;

							c.r = 1.0 - origc.r;
							c.g = 1.0 - origc.g;
							c.b = 1.0 - origc.b;
						}
						
						c.rgb *= origc.a;
						return c;
					}
						ENDCG

				}
		}
}