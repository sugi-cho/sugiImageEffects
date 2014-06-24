using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class ComputeTextures : MonoBehaviour
{
	public RenderTexture output;
	public TextureWrapMode wrapmode;
	public int
		width = 512,
		height = 512,
		depth = 0;
	public Material[]
		targetMats;
	public string
		propName = "_MainTex";
	public float
		updateFPS = 30f;
	public Material[]
		inits,
		updates;

	void Start ()
	{
		output = new RenderTexture (width, height, depth, RenderTextureFormat.ARGBHalf);
		output.wrapMode = wrapmode;
		output.Create ();

		if (targetMats.Length == 0 && renderer != null)
			targetMats = renderer.materials;

		for (int i = 0; i < inits.Length; i++) {
			Material effect = inits [i];
			effect.Render (output);
		}
		InvokeRepeating ("TextureUpdate", 1f / updateFPS, 1f / updateFPS);
	}

	void TextureUpdate ()
	{
		for (int i = 0; i < updates.Length; i++) {
			Material effect = updates [i];
			effect.Render (output);
		}
		foreach (var mat in targetMats) {
			mat.SetTexture (propName, output);
		}
	}
}
