Shader "Image Effects/Dots"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_HexWidth("Hex Width", Float) = 20
		_DotSoftness("Dot Softness", Float) = 0.2
		_BorderWidth("Border Width", Float) = 150
		_DotColor("Dot Color", Color) = (1, 1, 1, 1)
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
			float _DotSoftness;
			float _BorderWidth;
			fixed4 _DotColor;

			float4 uvToHex(float2 uv)
			{
				float2 pixelCoOrds = uv * _ScreenParams;
				float2 t = float2(1, 1.732) * _HexWidth;
				float2 h = t / 2;
				float2 lc1 = ((pixelCoOrds) % t) - h;
				float2 lc2 = ((pixelCoOrds + h) % t) - h;
				float2 localCoOrds = (length(lc1) < length(lc2)) ? lc1 : lc2;
				float2 centreCoOrds = pixelCoOrds - localCoOrds;
				localCoOrds /= _HexWidth / 2;
				centreCoOrds /= _ScreenParams;
				return float4(centreCoOrds.x, centreCoOrds.y, localCoOrds.x, localCoOrds.y);
			}

			float distanceToScreenEdge(float2 uv)
			{
				float2 pixelCoOrds = uv * _ScreenParams;
				float2 vectorToCorner = _ScreenParams / 2 - abs(pixelCoOrds - _ScreenParams / 2);
				return min(vectorToCorner.x, vectorToCorner.y);
			}

            fixed4 frag (v2f i) : SV_Target
            {
				float4 h = uvToHex(i.uv);
				float d = length(float2(h.z, h.w));
				fixed4 col = tex2D(_MainTex, float2(h.x, h.y));

				float brightness = col.r * 0.3 + col.g * 0.6 + col.b * 0.1; // Get approximate luma value
				brightness = saturate(brightness * 0.6); // Convert it from HDR to 0-1
				brightness *= smoothstep(0, _BorderWidth, distanceToScreenEdge(h.xy));

				col.rgb = _DotColor;
				col *= smoothstep(0, _DotSoftness, sqrt(brightness) - d);

				return col;
            }
            ENDCG
        }
    }
}
