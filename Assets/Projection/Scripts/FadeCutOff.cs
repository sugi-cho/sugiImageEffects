using UnityEngine;
using System.Collections;

public class FadeCutOff : MonoBehaviour
{
	public Material mat;
	bool edit;
	
	float
		p1, p2, p3, p4, p5, p6, p7, p8, p9, p10;
	
	// Use this for initialization
	void Start ()
	{
		p1 = PlayerPrefs.GetFloat ("p1", p1);
		p2 = PlayerPrefs.GetFloat ("p2", p2);
		p3 = PlayerPrefs.GetFloat ("p3", p3);
		p4 = PlayerPrefs.GetFloat ("p4", p4);
		p5 = PlayerPrefs.GetFloat ("p5", p5);
		p6 = PlayerPrefs.GetFloat ("p6", p6);
		p7 = PlayerPrefs.GetFloat ("p7", p7);
		p8 = PlayerPrefs.GetFloat ("p8", p8);
		p9 = PlayerPrefs.GetFloat ("p9", p9);
		p10 = PlayerPrefs.GetFloat ("p10", p10);
		
		SetProps ();
	}
	
	// Update is called once per frame
	void Update ()
	{
		if (Input.GetKeyDown (KeyCode.F))
			edit = !edit;
	}
	
	void OnGUI ()
	{
		if (!edit)
			return;
		
		Rect r = Rect.MinMaxRect (0, 0, Screen.width, Screen.height);
		r.y = Screen.height - r.y - r.height;
		r.width /= 2f;
		r.height /= 2f;
		r.x = r.width / 4f;
		r.y = r.height / 4f;

		GUILayout.BeginArea (r);
		GUILayout.BeginVertical ();
		
		p1 = GUILayout.HorizontalSlider (p1, 0, 1f);
		p2 = GUILayout.HorizontalSlider (p2, 0, 1f);
		p3 = GUILayout.HorizontalSlider (p3, 0, 1f);
		p4 = GUILayout.HorizontalSlider (p4, 0, 1f);
		p5 = GUILayout.HorizontalSlider (p5, 0, 1f);
		p6 = GUILayout.HorizontalSlider (p6, 0, 1f);
		p7 = GUILayout.HorizontalSlider (p7, 0, 1f);
		p8 = GUILayout.HorizontalSlider (p8, 0, 1f);
		p9 = GUILayout.HorizontalSlider (p9, 0, 1f);
		p10 = GUILayout.HorizontalSlider (p10, 0, 1f);
		
		GUILayout.EndVertical ();
		GUILayout.EndArea ();
		
		SetProps ();
		SaveProps ();
	}
	
	void SetProps ()
	{
		mat.SetFloat ("_P1", p1);
		mat.SetFloat ("_P2", p2);
		mat.SetFloat ("_P3", p3);
		mat.SetFloat ("_P4", p4);
		mat.SetFloat ("_P5", p5);
		mat.SetFloat ("_P6", p6);
		mat.SetFloat ("_P7", p7);
		mat.SetFloat ("_P8", p8);
		mat.SetFloat ("_P9", p9);
		mat.SetFloat ("_P10", p10);
	}
	
	void SaveProps ()
	{
		PlayerPrefs.SetFloat ("p1", p1);
		PlayerPrefs.SetFloat ("p2", p2);
		PlayerPrefs.SetFloat ("p3", p3);
		PlayerPrefs.SetFloat ("p4", p4);
		PlayerPrefs.SetFloat ("p5", p5);
		PlayerPrefs.SetFloat ("p6", p6);
		PlayerPrefs.SetFloat ("p7", p7);
		PlayerPrefs.SetFloat ("p8", p8);
		PlayerPrefs.SetFloat ("p9", p9);
		PlayerPrefs.SetFloat ("p10", p10);
	}
}
