using UnityEngine;
using System.Collections;

public class WebCamEffect : MonoBehaviour
{
	public Material effect;
	WebCamTexture wTex;

	// Use this for initialization
	void Start ()
	{
		wTex = new WebCamTexture (1280, 720);
		wTex.Play ();
	}

	void OnRenderImage (RenderTexture s, RenderTexture d)
	{
		Graphics.Blit (wTex, d, effect);
	}
}
