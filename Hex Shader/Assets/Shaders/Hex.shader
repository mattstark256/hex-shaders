Shader "Image Effects/Hex"
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

			float distanceToCenter(float2 coOrds)
			{
				coOrds = abs(coOrds);
				float d = dot(coOrds, float2(0.5, 0.866));
				return max(d, coOrds.x);
			}

            fixed4 frag (v2f i) : SV_Target
            {
				float4 h = uvToHex(i.uv);
				float d = distanceToCenter(float2(h.z, h.w));
				fixed4 col = tex2D(_MainTex, float2(h.x, h.y));
				col *= smoothstep(1, 0.8, d);

				return col;
            }
            ENDCG
        }
    }
}
