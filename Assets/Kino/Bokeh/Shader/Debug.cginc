//
// Kino/Bokeh - Depth of field effect
//
// Copyright (C) 2015, 2016 Keijiro Takahashi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#include "UnityCG.cginc"

sampler2D _MainTex;
float4 _MainTex_TexelSize;

half _MaxCoC;

// Fragment shader: CoC visualization
half4 frag_CoC(v2f_img i) : SV_Target
{
    half4 src = tex2D(_MainTex, i.uv);

    // CoC radius
    half coc = src.a / _MaxCoC;

    // Visualize CoC (blue -> red -> green)
    half3 rgb = lerp(half3(1, 0, 0), half3(0.8, 0.8, 1), max(0, -coc));
    rgb = lerp(rgb, half3(0.8, 1, 0.8), max(0, coc));

    // Black and white image overlay
    rgb *= dot(src.rgb, 0.5 / 3) + 0.5;

    // Gamma correction
    rgb = lerp(rgb, GammaToLinearSpace(rgb), unity_ColorSpaceLuminance.w);

    return half4(rgb, 1);
}
