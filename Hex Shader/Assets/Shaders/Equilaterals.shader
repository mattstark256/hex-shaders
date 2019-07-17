Shader "Image Effects/Equilaterals"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col;

				float2 pixelCoOrds = i.uv * _ScreenParams;
				float2 a = floor(float2(pixelCoOrds.x % 4, pixelCoOrds.y % 2));
				float2 b = floor(float2(pixelCoOrds.x % 8, pixelCoOrds.y % 4));
				float2 centreCoOrds = pixelCoOrds - a;

				if (a.x == b.x && a.y == b.y ||
					a.x != b.x && a.y != b.y)
				{
					// One sample per color
					fixed4 colA = tex2D(_MainTex, (centreCoOrds + float2(1, 1)) / _ScreenParams);
					fixed4 colB = tex2D(_MainTex, (centreCoOrds + float2(2, -1)) / _ScreenParams);
					fixed4 colC = tex2D(_MainTex, (centreCoOrds + float2(2, 3)) / _ScreenParams);

					// Four samples per color
					//fixed4 colA = 0.25 * (
					//	tex2D(_MainTex, (centreCoOrds + float2(0, 0)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(0, 2)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(1, 1)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(2, 1)) / _ScreenParams));
					//fixed4 colB = 0.25 * (
					//	tex2D(_MainTex, (centreCoOrds + float2(1, -1)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(2, -1)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(3, 0)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(3, -2)) / _ScreenParams));
					//fixed4 colC = 0.25 * (
					//	tex2D(_MainTex, (centreCoOrds + float2(1, 3)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(2, 3)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(3, 2)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(3, 4)) / _ScreenParams));

					if (a.x == 0 && a.y == 0 ||
						a.x == 0 && a.y == 1 ||
						a.x == 1 && a.y == 1 ||
						a.x == 2 && a.y == 1)
						col = colA;

					if (a.x == 1 && a.y == 0)
						col = 0.75 * colA + 0.25 * colB;

					if (a.x == 2 && a.y == 0)
						col = 0.25 * colA + 0.75 * colB;

					if (a.x == 3 && a.y == 0)
						col = colB;

					if (a.x == 3 && a.y == 1)
						col = 0.5 * colA + 0.25 * colB + 0.25 * colC;
				}
				else
				{
					// One sample per color
					fixed4 colA = tex2D(_MainTex, (centreCoOrds + float2(2, 1)) / _ScreenParams);
					fixed4 colB = tex2D(_MainTex, (centreCoOrds + float2(1, -1)) / _ScreenParams);
					fixed4 colC = tex2D(_MainTex, (centreCoOrds + float2(1, 3)) / _ScreenParams);

					// Four samples per color
					//fixed4 colA = 0.25 * (
					//	tex2D(_MainTex, (centreCoOrds + float2(1, 1)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(2, 1)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(3, 0)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(3, 2)) / _ScreenParams));
					//fixed4 colB = 0.25 * (
					//	tex2D(_MainTex, (centreCoOrds + float2(0, 0)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(0, -2)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(1, -1)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(2, -1)) / _ScreenParams));
					//fixed4 colC = 0.25 * (
					//	tex2D(_MainTex, (centreCoOrds + float2(0, 2)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(0, 4)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(1, 3)) / _ScreenParams) +
					//	tex2D(_MainTex, (centreCoOrds + float2(2, 3)) / _ScreenParams));

					if (a.x == 1 && a.y == 1 ||
						a.x == 2 && a.y == 1 ||
						a.x == 3 && a.y == 1 ||
						a.x == 3 && a.y == 0)
						col = colA;

					if (a.x == 2 && a.y == 0)
						col = 0.75 * colA + 0.25 * colB;

					if (a.x == 1 && a.y == 0)
						col = 0.25 * colA + 0.75 * colB;

					if (a.x == 0 && a.y == 0)
						col = colB;

					if (a.x == 0 && a.y == 1)
						col = 0.5 * colA + 0.25 * colB + 0.25 * colC;
				}

				return col;
            }
            ENDCG
        }
    }
}
