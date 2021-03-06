﻿Shader "Image Effects/Triangles"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_HexWidth("Hex Width", Float) = 100
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			float _HexWidth;

			float4 uvToHex(float2 uv)
			{
				float2 pixelCoOrds = uv * _ScreenParams;
				float2 a = floor(pixelCoOrds % 3);
				float2 b = floor(pixelCoOrds % 6);
				float2 centreCoOrds = pixelCoOrds - a;

				if (a.x == b.x && a.y == b.y ||
					a.x != b.x && a.y != b.y)
				{
					if (a.x == 0 && a.y == 0) centreCoOrds += float2(0, -3);
					if (a.x == 0 && a.y == 2) centreCoOrds += float2(0, 3);
				}
				else
				{
					if (a.x == 2 && a.y == 0) centreCoOrds += float2(0, -3);
					if (a.x == 2 && a.y == 2) centreCoOrds += float2(0, 3);
				}

				centreCoOrds /= _ScreenParams;
				return float4(centreCoOrds.x, centreCoOrds.y, 0, 0);
			}

            fixed4 frag (v2f i) : SV_Target
            {
				float4 h = uvToHex(i.uv);
				fixed4 col = tex2D(_MainTex, float2(h.x, h.y));

				return col;
            }
            ENDCG
        }
    }
}
