using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

public class TextureProcessor:EditorWindow
{
	[MenuItem("sugi.cho/Window/TextureProcessor")]
	public static void Init ()
	{
		EditorWindow window = EditorWindow.GetWindow<TextureProcessor> ();
		window.title = "TextureProcessor";
	}
	Texture2D
		rgbTex,
		alphaTex;
	void OnGUI ()
	{
		rgbTex = EditorGUILayout.ObjectField ("RGB Texture", rgbTex, typeof(Texture), false) as Texture2D;
		alphaTex = EditorGUILayout.ObjectField ("Alpha Texture", alphaTex, typeof(Texture), false) as Texture2D;
		if (GUILayout.Button ("Process") && rgbTex != null && alphaTex != null) {
			GenerateNewTex (false);
		}
		if (GUILayout.Button ("Create PNG") && rgbTex != null && alphaTex != null) {
			GenerateNewTex (true);
		}
	}
	void GenerateNewTex (bool png)
	{
		int
		width = rgbTex.width,
		height = rgbTex.height;
		Texture2D newTex = new Texture2D (width, height);
		
		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				Color c = rgbTex.GetPixel (x, y);
				if (x < alphaTex.width && y < alphaTex.height) {
					c.a = alphaTex.GetPixel (x, y).a;
				}
				newTex.SetPixel (x, y, c);
			}
		}
		newTex.Apply ();
		
		if (png) {
			byte[] bytes = newTex.EncodeToPNG ();
			
			var file = File.Create (Application.dataPath + "/" + rgbTex.name + ".png");
			BinaryWriter bw = new BinaryWriter (file);
			bw.Write (bytes);
			bw.Close ();
			AssetDatabase.Refresh ();
			return;
		}
		
		AssetDatabase.CreateAsset (newTex, string.Format ("Assets/{0}_blend.asset", rgbTex.name));
		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();
	}
}
