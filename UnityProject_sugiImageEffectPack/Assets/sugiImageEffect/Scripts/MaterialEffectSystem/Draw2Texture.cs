using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class Draw2Texture : MonoBehaviour
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
		propNameTarget = "_MainTex",
		propNameDraw = "_Draw",
		propNamePrev = "_Prev",
		propNameShape = "_ShapeTex";

	public float
		updateFPS = 30f;
	public bool draw2Screen;

	public Material[]
		inits,
		updates,
		brushes;
	
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
			mat.SetTexture (propNameTarget, output);
		}
	}

	public void PenDown (Vector4 prop, Texture brushShape = null, Material[] brushEffects = null)
	{
		Draw (prop, brushShape, brushEffects, true);
	}
	public void PenDraw (Vector4 prop, Texture brushShape = null, Material[] brushEffects = null)
	{
		Draw (prop, brushShape, brushEffects);
	}
	public void PenUp (Vector4 prop, Texture brushShape = null, Material[] brushEffects = null)
	{
		Draw (prop, brushShape, brushEffects);
	}

	void Draw (Vector4 prop, Texture brushShape, Material[] brushEffects, bool first = false)
	{
		if (brushEffects != null)
			brushes = brushEffects;
		if (brushShape != null)
			foreach (var b in brushes)
				b.SetTexture (propNameShape, brushShape);
		foreach (var b in brushes) {
			if (first)
				b.SetVector (propNamePrev, prop);
			b.SetVector (propNameDraw, prop);
			b.Render (output);
			b.SetVector (propNamePrev, prop);
		}
		foreach (var mat in targetMats)
			mat.SetTexture (propNameTarget, output);
	}

	void OnRenderImage (RenderTexture s, RenderTexture d)
	{
		if (draw2Screen)
			Graphics.Blit (output, d);
	}
}
