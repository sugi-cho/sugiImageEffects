using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;

public class CreateAnimationTexture
{
	[MenuItem("sugi.cho/Create/AnimationMaterial")]
	static void CreateMaterial ()
	{
		foreach (var go in Selection.gameObjects) {
			CreateMaterial (go);
		}
	}

	static void CreateMaterial (GameObject go)
	{
		GameObject selection = go;
		if (selection == null)
			return;
		Animation animation = selection.animation;
		if (animation == null)
			return;
		AnimationState state = animation [animation.clip.name];
		if (state == null)
			return;
		SkinnedMeshRenderer skinnedMesh = selection.GetComponentInChildren<SkinnedMeshRenderer> ();
		if (skinnedMesh == null)
			return;
		skinnedMesh.transform.localPosition = Vector3.zero;

		if (!EditorApplication.isPlaying)
			EditorApplication.isPlaying = true;

		selection.AddComponent<MonoB> ().StartCoroutine (CreateMaterial (selection, animation, state, skinnedMesh));
	}

	public static IEnumerator CreateMaterial (GameObject selection, Animation animation, AnimationState state, SkinnedMeshRenderer skinnedMesh)
	{
		Mesh mesh = new Mesh ();
		state.time = 0;
		state.speed = 0;
		yield return 0;
		animation.Play (state.name);
		skinnedMesh.BakeMesh (mesh);

		float
		minX = mesh.vertices [0].x,
		minY = mesh.vertices [0].y,
		minZ = mesh.vertices [0].z,
		maxX = mesh.vertices [0].x,
		maxY = mesh.vertices [0].y,
		maxZ = mesh.vertices [0].z;

		Mesh tmpMesh = new Mesh ();

		List<Vector3[]> verticesList = new List<Vector3[]> ();

		for (float time = 0; time < state.length+1f/24f; time += 1f / 24f) {
			state.time = time;
			yield return 0;
			skinnedMesh.BakeMesh (tmpMesh);
			Vector3[] vertices = tmpMesh.vertices;
			foreach (Vector3 v3 in vertices) {
				minX = Mathf.Min (minX, v3.x);
				minY = Mathf.Min (minY, v3.y);
				minZ = Mathf.Min (minZ, v3.z);

				maxX = Mathf.Max (maxX, v3.x);
				maxY = Mathf.Max (maxY, v3.y);
				maxZ = Mathf.Max (maxZ, v3.z);
			}
			verticesList.Add (vertices);
		}

		float
		scaleX = maxX - minX,
		scaleY = maxY - minY,
		scaleZ = maxZ - minZ;
		Vector4
		scale = new Vector4 (scaleX, scaleY, scaleZ, 1f),
		delta = new Vector4 (minX, minY, minZ, 1f);

		mesh.vertices = new Vector3[mesh.vertexCount];
		mesh.bounds = skinnedMesh.localBounds;
		
		Texture2D tex2d = new Texture2D (4096, 4096, TextureFormat.RGB24, false, PlayerSettings.colorSpace == ColorSpace.Linear);
		tex2d.filterMode = FilterMode.Point;
		tex2d.wrapMode = TextureWrapMode.Clamp;
		Vector2[] uv2 = new Vector2[mesh.vertexCount];

		for (int i = 0; i < uv2.Length; i++) {
			float f = 1f / 4096f;
			uv2 [i] = new Vector2 (f * (float)i, 0);
		}
		mesh.uv2 = uv2;
		for (int y = 0; y < verticesList.Count; y++) {
			Vector3[] vertices = verticesList [y];
			for (int x = 0; x < vertices.Length; x++) {
				Color c = new Color (0, 0, 0);
				float posX = (vertices [x].x - delta.x) / scale.x;
				float posY = (vertices [x].y - delta.y) / scale.y;
				float posZ = (vertices [x].z - delta.z) / scale.z;

				float d = 1f / 256f;
				c.r = Mathf.Floor (posX / d) * d;
				c.g = (posX - c.r) * 256f;
				c.b = Mathf.Floor (posY / d) * d;
				tex2d.SetPixel (x, y, c);

				c.r = (posY - c.b) * 256f;
				c.g = Mathf.Floor (posZ / d) * d;
				c.b = (posZ - c.g) * 256f;
				tex2d.SetPixel (x, y + 2048, c);
			}
		}
		tex2d.Apply ();

		AssetDatabase.CreateFolder ("Assets", "AnimationTex_" + selection.name);
		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();

		yield return 0;

		string folderPath = "Assets/" + "AnimationTex_" + selection.name;

		AssetDatabase.CreateAsset (tex2d, folderPath + "/" + selection.name + "Tex.asset");

		Material mat = new Material (Shader.Find ("VertexAnim/oneshot"));
		mat.mainTexture = skinnedMesh.material.mainTexture;
		mat.SetTexture ("_AnimTex", tex2d);
		mat.SetVector ("_Scale", scale);
		mat.SetVector ("_Delta", delta);
		mat.SetFloat ("_Speed", 24f);
		mat.SetFloat ("_AnimEnd", state.length);

		AssetDatabase.CreateAsset (mat, folderPath + "/" + selection.name + "Mat.mat");
		AssetDatabase.CreateAsset (mesh, folderPath + "/" + selection.name + "Mesh.asset");
		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();
		
		GameObject go = new GameObject (selection.name);
		go.transform.rotation = skinnedMesh.transform.rotation;
		go.transform.position = skinnedMesh.transform.position;
		go.AddComponent<MeshRenderer> ().material = mat;
		go.AddComponent<MeshFilter> ().mesh = mesh;
		go.AddComponent<SetInstantiateTime> ();
		go.AddComponent<Time2Destroy> ().time = 60f;
		PrefabUtility.CreatePrefab (folderPath + "/" + selection.name + ".prefab", go);
		
	}

	[MenuItem("sugi.cho/Create/PNG from Tex")]
	public static void CreatePNG ()
	{
		Texture2D tex2d = (Texture2D)Selection.activeObject;
		if (tex2d == null)
			return;

		byte[] bytes = tex2d.EncodeToPNG ();

		var file = File.Create (Application.dataPath + "/" + tex2d.name + ".png");
		BinaryWriter bw = new BinaryWriter (file);
		bw.Write (bytes);
		bw.Close ();
	}
	
	[MenuItem("sugi.cho/Mesh/SetBounds")]
	public static void SetBounds ()
	{
		foreach (Mesh mesh in Selection.objects) {
			if (mesh == null)
				continue;
			mesh.bounds = new Bounds (Vector3.zero, Vector3.one * 4f);
		}
	}
}
