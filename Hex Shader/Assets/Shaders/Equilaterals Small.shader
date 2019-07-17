Shader "Image Effects/Equilaterals Small"
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
				float2 a = floor(float2(pixelCoOrds.x % 3, pixelCoOrds.y % 3));
				float2 centreCoOrds = pixelCoOrds - a;

				if (a.x == floor(pixelCoOrds.x % 6))
				{
					a.x = 2 - a.x;
				}

				fixed4 colA = tex2D(_MainTex, (centreCoOrds + float2(1, 3)) / _ScreenParams);
				fixed4 colB = tex2D(_MainTex, (centreCoOrds + float2(1, 1)) / _ScreenParams);
				fixed4 colC = tex2D(_MainTex, (centreCoOrds + float2(1, 0)) / _ScreenParams);
				fixed4 colD = tex2D(_MainTex, (centreCoOrds + float2(1, -2)) / _ScreenParams);

				switch (a.x) {
				case 0:
					switch (a.y) {
					case 0:
						col = 0.5 * colB + 0.4375 * colC + 0.0625 * colD;
						break;
					case 1:
						col = colB;
						break;
					case 2:
						col = 0.9375 * colB + 0.0625 * colA;
						break;
					}
					break;
				case 1:
					switch (a.y) {
					case 0:
						col = 0.9375 * colC + 0.0625 * colB;
						break;
					case 1:
						col = 0.9375 * colB + 0.0625 * colC;
						break;
					case 2:
						col = 0.5 * colB + 0.5 * colA;
						break;
					}
					break;
				case 2:
					switch (a.y) {
					case 0:
						col = colC;
						break;
					case 1:
						col = 0.5 * colC + 0.4375 * colB + 0.0625 * colA;
						break;
					case 2:
						col = 0.9375 * colA + 0.0625 * colB;
						break;
					}
					break;
				}

				return col;
            }
            ENDCG
        }
    }
}
