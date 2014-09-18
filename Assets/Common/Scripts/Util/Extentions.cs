using UnityEngine;
using System.Collections;

static class Extentions
{

	public static Vector2 XY (this Vector3 vec3)
	{
		return new Vector2 (vec3.x, vec3.y);
	}
	public static Vector2 YZ (this Vector3 vec3)
	{
		return new Vector2 (vec3.y, vec3.z);
	}
	public static Vector2 ZX (this Vector3 vec3)
	{
		return new Vector2 (vec3.z, vec3.x);
	}

	public static Vector3 Position (this MonoBehaviour mb)
	{
		return mb.transform.position;
	}
	
	static Material bMat {
		get {
			if (_bMat == null)
				_bMat = new Material (Shader.Find ("Hidden/FastBlur"));
			return _bMat;
		}
	}
	static Material _bMat;
	public static RenderTexture GetBlur (this RenderTexture s, float bSize, int iteration = 1, int ds = 0)
	{
		float 
		widthMod = 1f / (1f * (1 << ds));

		int
		rtW = s.width >> ds,
		rtH = s.height >> ds;

		RenderTexture rt = RenderTexture.GetTemporary (rtW, rtH, s.depth, s.format);
		Graphics.Blit (s, rt);

		for (int i = 0; i < iteration; i++) {
			float iterationOffs = (float)i;
			bMat.SetVector ("_Parameter", new Vector4 (bSize * widthMod + iterationOffs, -bSize * widthMod - iterationOffs, 0, 0));
			
			RenderTexture rt2 = RenderTexture.GetTemporary (rtW, rtH, 0, rt.format);
			rt2.filterMode = FilterMode.Bilinear;
			Graphics.Blit (rt, rt2, bMat, 1);
			RenderTexture.ReleaseTemporary (rt);
			rt = rt2;
			
			rt2 = RenderTexture.GetTemporary (rtW, rtH, 0, rt.format);
			rt2.filterMode = FilterMode.Bilinear;
			Graphics.Blit (rt, rt2, bMat, 2);
			RenderTexture.ReleaseTemporary (rt);
			rt = rt2;
		}
		Graphics.Blit (rt, s);
		RenderTexture.ReleaseTemporary (rt);
		return s;
	}
}
