using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[RequireComponent(typeof(Camera))]
public class QuadWarp : MonoBehaviour
{
	public GameObject planePrefab;
	public Material
		quadWarpMat;
	public List<QuadWarpSetting>
		settingList = new List<QuadWarpSetting> ();
		
	int
		numX = 1,
		numY = 1;
	List<Material> matList = new List<Material> ();
	
	public void Create (int nx, int ny)
	{
		foreach (var r in GetComponentsInChildren<Renderer>()) 
			Destroy (r.gameObject);
		foreach (var m in matList)
			Destroy (m);
		matList.Clear ();
		settingList.Clear ();
		
		numX = nx;
		numY = ny;
		for (int y = 0; y < numY; y++) {
			for (int x = 0; x < numX; x++) {
				CreatePlane (x, y);
				LoadProp (x, y);
			}
		}
	}
	
	public void EditProp (int index, Vector2 bl, Vector2 br, Vector2 ul, Vector2 ur)
	{
		var m = matList [index];
		var setting = settingList [index];
		
		setting.bl = bl;
		setting.br = br;
		setting.ul = ul;
		setting.ur = ur;
		
		m.SetVector ("_BL", bl);
		m.SetVector ("_BR", br);
		m.SetVector ("_UL", ul);
		m.SetVector ("_UR", ur);
		
		PlayerPrefs.SetString (string.Format ("QuadWarpProp_{0}", index.ToString ("000")), string.Format ("{0},{1},{2},{3},{4},{5},{6},{7}", bl.x, bl.y, br.x, br.y, ul.x, ul.y, ur.x, ur.y));
	}
	
	void LoadProp (int x, int y)
	{
		int index = x + y * numX;
		var m = matList [index];
		var setting = settingList [index];
		
		string prefString = PlayerPrefs.GetString (string.Format ("QuadWarpProp_{0}", index.ToString ("000")), "0,0,1,0,0,1,1,1");
		string[] strs = prefString.Split (',');

		setting.bl = new Vector2 (float.Parse (strs [0]), float.Parse (strs [1]));
		setting.br = new Vector2 (float.Parse (strs [2]), float.Parse (strs [3]));
		setting.ul = new Vector2 (float.Parse (strs [4]), float.Parse (strs [5]));
		setting.ur = new Vector2 (float.Parse (strs [6]), float.Parse (strs [7]));

		m.SetVector ("_BL", setting.bl);
		m.SetVector ("_BR", setting.br);
		m.SetVector ("_UL", setting.ul);
		m.SetVector ("_UR", setting.ur);
	}
	
	GameObject CreatePlane (int x, int y)
	{
		GameObject plane = (GameObject)Instantiate (planePrefab);
		plane.layer = gameObject.layer;
		
		plane.transform.parent = transform;
		plane.transform.localPosition = transform.forward;
		
		Vector2 scale = Vector2.one * camera.orthographicSize;
		scale.x *= camera.pixelRect.width / camera.pixelRect.height;
		
		Material mat = plane.renderer.material;
		mat.mainTexture = quadWarpMat.mainTexture;
		mat.SetVector ("_Prop1", scale);
		mat.SetVector ("_Prop2", new Vector4 (x, y, 1f / (float)numX, 1f / (float)numY));
		
		matList.Add (mat);
		QuadWarpSetting setting = new QuadWarpSetting ();
		settingList.Add (setting);
		
		return plane;
	}
	[System.Serializable]
	public class QuadWarpSetting
	{
		public Vector2
			bl,
			br,
			ul,
			ur;
	}
}
