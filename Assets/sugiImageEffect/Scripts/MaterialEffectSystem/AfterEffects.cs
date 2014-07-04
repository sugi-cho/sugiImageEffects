using UnityEngine;
using System.Collections;

public class AfterEffects : MonoBehaviour
{
	public RenderTexture output;
	public TextureWrapMode wrapmode;

	public Material[] effects;
	public int iterate = 1;
	
	public Material[] targetMats;
	public string propNameTarget = "_Tex";

	void CreateOutput (RenderTexture s)
	{
		if (output != null)
			Destroy (output);
		output = new RenderTexture (s.width, s.height, s.depth, s.format);
		output.wrapMode = wrapmode;
		output.Create ();
	}

	void OnRenderImage (RenderTexture s, RenderTexture d)
	{
		if (output == null || output.width != s.width || output.height != s.height)
			CreateOutput (s);
		RenderTexture rt = RenderTexture.GetTemporary (s.width, s.height, s.depth, s.format);
		Graphics.Blit (s, rt);
		for (int i = 0; i < effects.Length; i++) {
			RenderTexture rt1 = RenderTexture.GetTemporary (s.width, s.height, s.depth, s.format);
			Material effect = effects [i];
			effect.Render (rt, rt1, iterate);
			Graphics.Blit (rt1, rt);
			RenderTexture.ReleaseTemporary (rt1);
		}
		Graphics.Blit (rt, output);
		Graphics.Blit (output, d);
		foreach (var mat in targetMats)
			mat.SetTexture (propNameTarget, output);
		RenderTexture.ReleaseTemporary (rt);
	}
}
