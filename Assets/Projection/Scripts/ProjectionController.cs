using UnityEngine;
using System.Collections;

public class ProjectionController : MonoBehaviour
{
	public int
		numX = 1,
		numY = 1;
	public Material
		pBlendMat;
	
	QuadWarp qw;
	
	float
		overlapX,
		overlapY,
		offset,
		alpha,
		power;
	
	
	string
		propNameNumX = "ProjectionControllerNumX",
		propNameNumY = "ProjectionControllerNumY",
		propNameOverlapX = "ProjectionControllerOverlapX",
		propNameOverlapY = "ProjectionControllerOverlapY",
		propNameBlendOffset = "ProjectionControllerBlendOffset",
		propNameBlendA = "ProjectionControllerBlendA",
		propNameBlendP = "ProjectionControllerBlendP";
	bool 
		editBlend,
		editQuad;
	
	void Awake ()
	{
		LoadSetting ();
	}
	
	// Use this for initialization
	void Start ()
	{
		qw = GetComponentInChildren<QuadWarp> ();
		numX = Mathf.Clamp (numX, 1, 20);
		numY = Mathf.Clamp (numY, 1, 20);
		qw.Create (numX, numY);
	}
	
	// Update is called once per frame
	void Update ()
	{
		if (Input.GetKeyDown (KeyCode.B))
			editBlend = !editBlend;
		if (Input.GetKeyDown (KeyCode.Q))
			editQuad = !editQuad;
	}
	
	void LoadSetting ()
	{
		numX = PlayerPrefs.GetInt (propNameNumX, numX);
		numY = PlayerPrefs.GetInt (propNameNumY, numY);
		
		overlapX = PlayerPrefs.GetFloat (propNameOverlapX, pBlendMat.GetFloat ("_OX"));
		overlapY = PlayerPrefs.GetFloat (propNameOverlapY, pBlendMat.GetFloat ("_OY"));
		offset = PlayerPrefs.GetFloat (propNameBlendOffset, pBlendMat.GetFloat ("_O"));
		alpha = PlayerPrefs.GetFloat (propNameBlendA, pBlendMat.GetFloat ("_A"));
		power = PlayerPrefs.GetFloat (propNameBlendP, pBlendMat.GetFloat ("_P"));
		
		pBlendMat.SetFloat ("_NX", numX);
		pBlendMat.SetFloat ("_NY", numY);
		pBlendMat.SetFloat ("_OX", overlapX);
		pBlendMat.SetFloat ("_OY", overlapY);
		pBlendMat.SetFloat ("_O", offset);
		pBlendMat.SetFloat ("_A", alpha);
		pBlendMat.SetFloat ("_P", power);
	}
	
	void EditNum (int nx, int ny)
	{
		numX = nx;
		numY = ny;
		pBlendMat.SetFloat ("_NX", numX);
		pBlendMat.SetFloat ("_NY", numY);
		PlayerPrefs.SetInt (propNameNumX, numX);
		PlayerPrefs.SetInt (propNameNumY, numY);
		qw.Create (numX, numY);
	}
	
	void EditBlend (float ox, float oy, float os, float a, float p)
	{
		overlapX = ox;
		overlapY = oy;
		offset = os;
		alpha = a;
		power = p;
		
		pBlendMat.SetFloat ("_OX", overlapX);
		pBlendMat.SetFloat ("_OY", overlapY);
		pBlendMat.SetFloat ("_O", offset);
		pBlendMat.SetFloat ("_A", alpha);
		pBlendMat.SetFloat ("_P", power);
		
		PlayerPrefs.SetFloat (propNameOverlapX, overlapX);
		PlayerPrefs.SetFloat (propNameOverlapY, overlapY);
		PlayerPrefs.SetFloat (propNameBlendOffset, offset);
		PlayerPrefs.SetFloat (propNameBlendA, alpha);
		PlayerPrefs.SetFloat (propNameBlendP, power);
	}
	
	void OnGUI ()
	{
		if (editBlend) {
			GUILayout.BeginArea (Rect.MinMaxRect (0, 0, Screen.width, Screen.height));
			GUILayout.BeginVertical ();
			
			int 
			nx = IntField ("numX:", numX, 1, 20),
			ny = IntField ("numY:", numY, 1, 20);
			
			float
			ox = FloatField ("overlapX:", overlapX, 0, 1f),
			oy = FloatField ("overlapY:", overlapY, 0, 1f),
			os = FloatField ("offset", offset, 0, 1f),
			a = FloatField ("blendAlpha:", alpha, 0, 3f),
			p = FloatField ("blendPower:", power, 0, 3f);
				
			GUILayout.EndVertical ();
			GUILayout.EndArea ();
			
			if (numX != nx || numY != ny)
				EditNum (nx, ny);
			if (overlapX != ox || overlapY != oy || offset != os || alpha != a || power != p)
				EditBlend (ox, oy, os, a, p);
		}
		if (editQuad) {
			for (int y = 0; y < numY; y++) {
				for (int x = 0; x < numX; x++) {
					Rect rect = Rect.MinMaxRect (0, 0, Screen.width, Screen.height);
					rect.width /= numX;
					rect.height /= numY;
					rect.x += x * rect.width;
					rect.y = Screen.height - (y + 1) * rect.height;
					GUILayout.BeginArea (rect);
					GUILayout.BeginVertical ();
					SetQuadWarp (x, y);
					GUILayout.EndVertical ();
					GUILayout.EndArea ();
					
				}
			}
		}
	}
	
	void SetQuadWarp (int x, int y)
	{
		int index = x + y * numX;
		QuadWarp.QuadWarpSetting setting = qw.settingList [index];
		
		float
		blx = FloatField ("P1:", setting.bl.x),
		bly = FloatField ("P2:", setting.bl.y),
		brx = FloatField ("P3:", setting.br.x),
		bry = FloatField ("P4:", setting.br.y),
		ulx = FloatField ("P5:", setting.ul.x),
		uly = FloatField ("P6:", setting.ul.y),
		urx = FloatField ("P7:", setting.ur.x),
		ury = FloatField ("P8:", setting.ur.y);
		
		Vector2
		bl = new Vector2 (blx, bly),
		br = new Vector2 (brx, bry),
		ul = new Vector2 (ulx, uly),
		ur = new Vector2 (urx, ury);
		
		if (setting.bl != bl || setting.br != br || setting.ul != ul || setting.ur != ur)
			qw.EditProp (index, bl, br, ul, ur);
	}
	
	float FloatField (string label, float val, float min = 0, float max = 1f)
	{
		GUILayout.BeginHorizontal ();
		GUILayout.Label (label);
		string s = GUILayout.TextField (val.ToString ());
		float f;
		if (float.TryParse (s, out f))
			val = f;
		GUILayout.EndHorizontal ();
		val = GUILayout.HorizontalSlider (val, min, max);
		val = Mathf.Clamp (val, min, max);
		return val;
	}
	
	int IntField (string label, int val, int min = 0, int max = 10)
	{
		float f = FloatField (label, val, min, max);
		return Mathf.FloorToInt (f);
	}
}
