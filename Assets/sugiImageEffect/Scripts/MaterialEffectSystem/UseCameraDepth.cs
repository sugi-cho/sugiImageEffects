using UnityEngine;
using System.Collections;

public class UseCameraDepth : MonoBehaviour
{
	
	public Material mat;
	public RenderTexture output;
	
	void Start ()
	{
		camera.depthTextureMode = DepthTextureMode.DepthNormals;
	}

	
	// Called by the camera to apply the image effect
	void OnRenderImage (RenderTexture s, RenderTexture d)
	{

		if (output == null)
			output = new RenderTexture (s.width, s.height, s.depth, s.format);
		//mat is the material containing your shader
//		Graphics.Blit (s, d, mat);
//		output.DiscardContents ();
		Graphics.Blit (s, output, mat);
		Graphics.Blit (output, d);

		//mat.Render (s);
//		Graphics.Blit (s, output, mat);
//		Graphics.Blit (output, d);
	}
}