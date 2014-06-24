using UnityEngine;
using System.Collections;

static class MaterialRenderExtensions
{	
	public static void Render (this Material effectMat, RenderTexture s, RenderTexture d, int iterate = 1)
	{
		RenderTexture rt = RenderTexture.GetTemporary (s.width, s.height, s.depth, s.format);
		rt.filterMode = s.filterMode;
		rt.wrapMode = s.wrapMode;
		Graphics.Blit (s, rt);
		for (int i = 0; i < iterate; i++) {
			for (int j = 0; j < effectMat.passCount; j++) {
				RenderTexture rt2 = RenderTexture.GetTemporary (s.width, s.height, s.depth, s.format);
				rt2.filterMode = s.filterMode;
				rt2.wrapMode = s.wrapMode;
				Graphics.Blit (rt, rt2, effectMat, j);
				RenderTexture.ReleaseTemporary (rt);
				rt = rt2;

			}
		}

		Graphics.Blit (rt, d);
		RenderTexture.ReleaseTemporary (rt);
	}
	
	public static void Render (this Material effectMat, RenderTexture r, int iterate = 1)
	{
		effectMat.Render (r, r, iterate);
	}
}
