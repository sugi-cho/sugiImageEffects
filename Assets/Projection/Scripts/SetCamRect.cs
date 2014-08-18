using UnityEngine;
using System.Collections;

public class SetCamRect : MonoBehaviour
{
	public Camera[] cams;
	string
		propRectMinX = "RectMinX",
		propRectMinY = "RectMinY",
		propRectMaxX = "RectMaxX",
		propRectMaxY = "RectMaxY";
	float
		minX = 0,
		minY = 0,
		maxX = 1f,
		maxY = 1f;
	bool e;

	void LoadProps ()
	{
		minX = PlayerPrefs.GetFloat (propRectMinX, minX);
		minY = PlayerPrefs.GetFloat (propRectMinY, minY);
		maxX = PlayerPrefs.GetFloat (propRectMaxX, maxX);
		maxY = PlayerPrefs.GetFloat (propRectMaxY, maxY);
	}

	void SaveProps ()
	{
		PlayerPrefs.SetFloat (propRectMinX, minX);
		PlayerPrefs.SetFloat (propRectMinY, minY);
		PlayerPrefs.SetFloat (propRectMaxX, maxX);
		PlayerPrefs.SetFloat (propRectMaxY, maxY);
	}

	void SetProps ()
	{
		foreach (var cam in cams) {
			cam.rect = Rect.MinMaxRect (minX, minY, maxX, maxY);
		}
	}

	// Use this for initialization
	void Awake ()
	{
		if (cams.Length == 0)
			cams = GetComponentsInChildren<Camera> ();
		LoadProps ();
		SetProps ();
	}
	
	// Update is called once per frame
	void Update ()
	{
		if (Input.GetKeyDown (KeyCode.E)) {
			e = !e;
			SaveProps ();
		}
	}

	void OnGUI ()
	{
		if (!e)
			return;

		Rect r = Rect.MinMaxRect (Screen.width / 4f, Screen.height / 4f, Screen.width * 3f / 4f, Screen.height * 3f / 4f);
		GUILayout.BeginArea (r);
		GUILayout.BeginVertical ();
		
		minX = FloatField ("min x: ", minX);
		minX = GUILayout.HorizontalSlider (minX, 0, 1f);
		
		minY = FloatField ("min y: ", minY);
		minY = GUILayout.HorizontalSlider (minY, 0, 1f);
		
		maxX = FloatField ("max x: ", maxX);
		maxX = GUILayout.HorizontalSlider (maxX, 0, 1f);
		
		maxY = FloatField ("max y: ", maxY);
		maxY = GUILayout.HorizontalSlider (maxY, 0, 1f);
		
		GUILayout.EndVertical ();
		GUILayout.EndArea ();

		SetProps ();
	}
	
	float FloatField (string label, float val)
	{
		GUILayout.BeginHorizontal ();
		GUILayout.Label (label);
		string s = GUILayout.TextField (val.ToString ());
		float f;
		if (float.TryParse (s, out f))
			val = f;
		GUILayout.EndHorizontal ();
		return val;
	}
}
