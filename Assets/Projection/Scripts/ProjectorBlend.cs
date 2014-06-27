using UnityEngine;
using System.Collections;

public class ProjectorBlend : MonoBehaviour
{
	public Material
		blendMat,
		blendMat2;
	
	float
		blendW,
		blendP,
		blendA,
		blendO;

	bool twoDisplay;

	Material mat;

	string
		propBlendW = "BlendW",
		propBlendP = "BlendP",
		propBlendA = "BlendA",
		propBlendO = "BlendO",
		propTwoDisplay = "TwoDisplay";

	bool edit;
	
	void LoadProps ()
	{
		blendW = PlayerPrefs.GetFloat (propBlendW, blendMat.GetFloat ("_W"));
		blendP = PlayerPrefs.GetFloat (propBlendP, blendMat.GetFloat ("_P"));
		blendA = PlayerPrefs.GetFloat (propBlendA, blendMat.GetFloat ("_A"));
		blendO = PlayerPrefs.GetFloat (propBlendO, blendMat.GetFloat ("_O"));

		twoDisplay = PlayerPrefs.GetInt (propTwoDisplay, twoDisplay ? 1 : 0) == 1;
	}
	void SaveProps ()
	{
		PlayerPrefs.SetFloat (propBlendW, blendW);
		PlayerPrefs.SetFloat (propBlendP, blendP);
		PlayerPrefs.SetFloat (propBlendA, blendA);
		PlayerPrefs.SetFloat (propBlendO, blendO);

		PlayerPrefs.SetInt (propTwoDisplay, twoDisplay ? 1 : 0);
	}
	void SetProps ()
	{
		if (twoDisplay)
			mat = blendMat2;
		else
			mat = blendMat;
		
		mat.SetFloat ("_W", blendW);
		mat.SetFloat ("_P", blendP);
		mat.SetFloat ("_A", blendA);
		mat.SetFloat ("_O", blendO);

	}
	
	void Awake ()
	{
		LoadProps ();
		SetProps ();
		Screen.showCursor = false;
	}
	
	void Update ()
	{
		if (Input.GetKeyDown (KeyCode.E)) {
			edit = !edit;
			SaveProps ();
			Screen.showCursor = true;
		}
		if (Input.GetKeyDown (KeyCode.S))
			Screen.showCursor = false;
	}

	void OnRenderImage (RenderTexture s, RenderTexture d)
	{
		if (mat != null)
			Graphics.Blit (s, d, mat);
	}
	
	void OnGUI ()
	{
		if (!edit)
			return;
		Rect r = Camera.main.pixelRect;
		r.width /= 3f;
		r.y = Screen.height - r.height - r.y;
		GUILayout.BeginArea (r);
		GUILayout.BeginVertical ();

		blendW = FloatField ("Blend W: ", blendW);
		blendW = GUILayout.HorizontalSlider (blendW, 0, 1f);

		blendP = FloatField ("Blend Power: ", blendP);
		blendP = GUILayout.HorizontalSlider (blendP, 1f, 3f);

		blendA = FloatField ("Blend A: ", blendA);
		blendA = GUILayout.HorizontalSlider (blendA, 0, 1f);

		blendO = FloatField ("Blend Offset: ", blendO);
		blendO = GUILayout.HorizontalSlider (blendO, 0, 10f);

		twoDisplay = GUILayout.Toggle (twoDisplay, "Two Projection?");
		
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
