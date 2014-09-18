using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif
using System.Collections;

public class VertToTexture : MonoBehaviour
{
	#region static members
#if UNITY_EDITOR
	[MenuItem("sugi.cho/Create/posTex")]
	public static void MenuCreatePositionTexture ()
	{
		foreach (var o in Selection.objects) {
			Mesh mesh = (Mesh)o;
			if (mesh != null) {
				CreatePosTexMat (mesh);
			}
		}
		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();
	}
#endif
	static Material CreatePosTexMat (Mesh mesh)
	{
		Vector3[] vertices = mesh.vertices;
		int 
		numPixels = Mathf.NextPowerOfTwo (vertices.Length * 2),
		log2 = Mathf.FloorToInt (Mathf.Log ((float)numPixels, 2f)),
		width = Mathf.FloorToInt (log2 / 2f),
		height = log2 - width;
		
		width = (int)Mathf.Pow (2, width);
		height = (int)Mathf.Pow (2, height);
		
		Texture2D tex2d = new Texture2D (width, height, TextureFormat.ARGB32, false);
		tex2d.wrapMode = TextureWrapMode.Clamp;
		tex2d.filterMode = FilterMode.Point;
		
		float
		minX, minY, minZ, maxX, maxY, maxZ;
		
		minX = minY = minZ = float.MaxValue;
		maxX = maxY = maxZ = float.MinValue;
		foreach (var vec3 in vertices) {
			minX = Mathf.Min (vec3.x, minX);
			minY = Mathf.Min (vec3.y, minY);
			minZ = Mathf.Min (vec3.z, minZ);
			
			maxX = Mathf.Max (vec3.x, maxX);
			maxY = Mathf.Max (vec3.y, maxY);
			maxZ = Mathf.Max (vec3.z, maxZ);
		}
		Vector3 offset = new Vector3 (
			minX, minY, minZ
		);
		Vector3 scale = new Vector3 (
			maxX - minX, maxY - minY, maxZ - minZ
		);
		
		for (int y = 0; y < height/2; y++) {
			for (int x = 0; x < width; x++) {
				int i = y * width + x;
				if (i < vertices.Length) {
					Vector3 vert = vertices [i];
					vert -= offset; //all verts move to positive position
					vert.x /= scale.x;
					vert.y /= scale.y;
					vert.z /= scale.z; //all verts position is between 0 to 1
					
					Color 
					c1 = new Color (vert.x, vert.y, vert.z),
					c2 = new Color (vert.x * 256f - Mathf.Floor (vert.x * 256f), vert.y * 256f - Mathf.Floor (vert.y * 256f), vert.y * 256f - Mathf.Floor (vert.y * 256f));
					
					tex2d.SetPixel (x, y, c1);
					tex2d.SetPixel (x, y + height / 2, c2);
					
					Debug.Log (string.Format ("{0},{1}", c1, c2));
				}
			}
		}
		tex2d.Apply ();
		Material mat = new Material (Shader.Find ("Custom/PosTexToRT"));
		mat.SetVector ("_Offset", offset);
		mat.SetVector ("_Scale", scale);
		mat.SetTexture ("_MainTex", tex2d);
#if UNITY_EDITOR
		AssetDatabase.CreateFolder ("Assets/sugiMesh", "PosTestures");
		
		AssetDatabase.CreateAsset (tex2d, string.Format ("Assets/sugiMesh/PosTestures/{0}_postex.asset", mesh.name));
		AssetDatabase.CreateAsset (mat, string.Format ("Assets/sugiMesh/PosTestures/{0}_decodeMat.mat", mesh.name));
#endif
		return mat;
	}
	#endregion
	
	public Mesh targetMesh;
	public Material decodeMat;
	public FilterMode filterMode;
	RenderTexture posRendrTex;
	Material mat;
	
	void Awake ()
	{
		mat = renderer.material;
		if (decodeMat == null) {
			if (targetMesh == null) {
				Destroy (this);
				return;
			}
			decodeMat = CreatePosTexMat (targetMesh);
		}
		posRendrTex = PosTexToRenderTex (decodeMat);
		mat.SetTexture ("_Position", posRendrTex);
	}
	
	RenderTexture PosTexToRenderTex (Material decodeMat)
	{
		Texture tex = decodeMat.mainTexture;
		RenderTexture rt = new RenderTexture (tex.width, tex.height / 2, 0, RenderTextureFormat.ARGBHalf);
		rt.filterMode = filterMode;
		rt.Create ();
		Graphics.Blit (tex, rt, decodeMat);
		return rt;
	}
	
	void OnDestroy ()
	{
		if (mat != null)
			Destroy (mat);
	}
}

