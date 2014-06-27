using UnityEngine;
using UnityEditor;
using System.Collections;

public class CreateTex3D : EditorWindow
{
	public static void Init ()
	{
		EditorWindow window = EditorWindow.GetWindow (typeof(CreateTex3D));
		window.title = "3DNoise";
	}

	int 
		count = 0,
		size = 256;
	IEnumerator coroutine;

	void OnGUI ()
	{
		if (count > 0) {
			float progress = (float)count / (float)(size * size * size);
			EditorGUI.ProgressBar (Rect.MinMaxRect (0, 0, position.width, 25f), progress, (progress * 100f).ToString ("000.0") + "%");
			if (GUI.Button (Rect.MinMaxRect (0, position.height - 25f, position.width, position.height), "Cancel")) {
				count = 0;
				EditorApplication.update -= Process;
				coroutine = null;
			}
			return;
		}
		size = EditorGUILayout.IntField (size);
		if (GUILayout.Button ("Create")) {
			count = 0;
			coroutine = ProcessCoroutine ();
			EditorApplication.update += Process;
		}
	}

	void Process ()
	{
		if (!coroutine.MoveNext ()) {
			count = 0;
			EditorApplication.update -= Process;
			coroutine = null;
		}
	}

	IEnumerator ProcessCoroutine ()
	{
		Color[] cs = new Color[size * size * size];
		int i = 0;
		for (int z = 0; z < size; z++) {
			for (int y = 0; y < size; y++) {
				for (int x = 0; x < size; x++) {
					Color c = Color.red;
					Vector3 v = new Vector3 (5f * ((float)x / size), 5f * ((float)y / size), 5f * ((float)z / size));

					c.r = GetFbmLoop (v, 1);
					c.g = GetFbmLoop (v, 2);
					c.b = GetFbmLoop (v, 3);
					c.a = GetFbmLoop (v, 4);

					cs [i] = c;
					count = i++;
					if (i % 100 == 0)
						yield return 0;
				}
			}
		}
		Texture3D t3d = new Texture3D (size, size, size, TextureFormat.ARGB32, false);
		t3d.SetPixels (cs);
		t3d.Apply ();

		AssetDatabase.CreateAsset (t3d, "Assets/perlin3d_" + size + ".asset");
		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();

		Selection.activeObject = t3d;
		count = 0;
	}


	float GetFbmLoop (Vector3 v, int octave)
	{

		Vector3 v1 = v;
		v1.x -= 5f;
		
		float
		f = GetLoopY (v, octave),
		f1 = GetLoopY (v1, octave);
		f = Mathf.Lerp (f, f1, v.x / 5f);

		return f / 2f + 0.5f;
	}

	float GetLoopY (Vector3 v, int octave)
	{

		Vector3 v1 = v;
		v1.y -= 5f;
		
		float
		f = GetLoopZ (v, octave),
		f1 = GetLoopZ (v1, octave);
		f = Mathf.Lerp (f, f1, v.y / 5f);
		
		return f;
	}

	float GetLoopZ (Vector3 v, int octave)
	{
		
		Vector3 v1 = v;
		v1.z -= 5f;
		
		float
		f = Perlin.Fbm (v, octave),
		f1 = Perlin.Fbm (v1, octave);
		f = Mathf.Lerp (f, f1, v.z / 5f);
		
		return f;
	}
}
