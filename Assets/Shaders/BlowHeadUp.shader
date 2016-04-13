Shader "Pablo/BlowHeadUp" {
	Properties{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_DissolveTex("Blow Up Texture", 2D) = "white" {}
		[Toggle]_BlowUp("Blow up", float) = 0.0
		

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

					float _BlowUp;
					
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
					sampler2D _DissolveTex;
					fixed4 frag(v2f IN) : SV_Target
					{
						fixed4 c = tex2D(_MainTex, IN.texcoord);
						fixed4 dissolveMask = tex2D(_DissolveTex,IN.texcoord);					
						

						c.rgb *= c.a;

						if (dissolveMask.r < IN.texcoord.y  && _BlowUp >0.0)
						{
							//discard;
							c = fixed4(0.0, 0.0, 0.0, 0.0);
						}

						
							//
							 


						return c;
					}
						ENDCG

				}
		}
}