using UnityEngine;
using System.Collections;

public class RenderEffect : MonoBehaviour
{
	public string label = "discription";
	public RenderTexture output;
	public TextureWrapMode wrapmode = TextureWrapMode.Clamp;
	public Material[] inits, effects;
	public Material[] targetMats;
	public string propNameTarget = "_Tex";
	public bool
		show = true,
		compute = false,
		getBlur = false;

	public float blurSize = 3f;
	public int
		blurIter = 3,
		blurDS = 1,
		baseHeight = 720;
	
	void Start ()
	{
		if (getBlur)
			blurSize = (float)Screen.height / (float)baseHeight;
	}
	
	void OnRenderImage (RenderTexture s, RenderTexture d)
	{
		if (compute) {
			if (output == null) {
				CreateOutput (s);
				RenderOutput (output, inits);
			}
			RenderOutput (output);
		} else
			RenderOutput (s);
		
		if (getBlur)
			output.GetBlur (blurSize, blurIter, blurDS);
		
		for (int i = 0; i < targetMats.Length; i++) {
			Material target = targetMats [i];
			target.SetTexture (propNameTarget, output);
		}
		
		if (show)
			Graphics.Blit (output, d);
		else
			Graphics.Blit (s, d);
	}
	void RenderOutput (RenderTexture s)
	{
		RenderOutput (s, effects);
	}
	void RenderOutput (RenderTexture s, Material[] effects)
	{
		if (output == null || output.width != s.width || output.height != s.height)
			CreateOutput (s);
		
		if (effects.Length > 0) {
			RenderTexture rt = RenderTexture.GetTemporary (s.width, s.height, s.depth, s.format);
			Graphics.Blit (s, rt);
			for (int i = 0; i < effects.Length; i++) {
				Material effect = effects [i];
				for (int j = 0; j < effect.passCount; j++) {
					Graphics.Blit (rt, output, effect, j);
					Graphics.Blit (output, rt);
				}
			}
			RenderTexture.ReleaseTemporary (rt);
		} else
			Graphics.Blit (s, output);
	}
	
	void CreateOutput (RenderTexture s)
	{
		if (output != null) {
			Destroy (output);
		}
		output = new RenderTexture (s.width, s.height, s.depth, s.format);
		output.wrapMode = wrapmode;
		output.Create ();
		Graphics.Blit (s, output);
	}
}
