using UnityEngine;
using System.Collections;

public class EasyBlur : MonoBehaviour
{
	public float bSize = 1f;
	public int
		itera = 3,
		ds = 0;

	void OnRenderImage (RenderTexture s, RenderTexture d)
	{
		Graphics.Blit (s.GetBlur (bSize, itera, ds), d);
	}
}
