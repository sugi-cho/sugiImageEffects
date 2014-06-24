using UnityEngine;
using System.Collections;

public class WebcamPainter : MonoBehaviour
{
	public RenderTexture
		penPos,
		output;
	public Material
		initBlack,
		initUV,
		mixMat,
		blurMat,
		culcPosMat,
		drawPointsMat;
	WebCamTexture wTex;
	// Use this for initialization
	void Start ()
	{
		penPos = new RenderTexture (8, 8, 0, RenderTextureFormat.ARGBHalf);
		penPos.filterMode = FilterMode.Point;
		initUV.Render (penPos);
		output = new RenderTexture (Screen.width, Screen.height, 0, RenderTextureFormat.ARGBHalf);
		initBlack.Render (output);

		wTex = new WebCamTexture (640, 480, 30);
		wTex.Play ();

	}
	
	// Update is called once per frame
	void Update ()
	{
	
	}

	void OnRenderImage (RenderTexture s, RenderTexture d)
	{
		RenderTexture rt = RenderTexture.GetTemporary (output.width, output.height, output.depth, output.format);
		Graphics.Blit (wTex, rt);
		mixMat.SetTexture ("_NegaTex", output);
		mixMat.Render (rt);
		blurMat.Render (rt, 3);

		culcPosMat.SetTexture ("_STex", rt);
		culcPosMat.Render (penPos);
		drawPointsMat.SetTexture ("_PTex", penPos);
		drawPointsMat.Render (output);
		Graphics.Blit (output, d);
		RenderTexture.ReleaseTemporary (rt);
	}
}
