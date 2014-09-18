using UnityEngine;
using System.Collections;

public class DrawScreen : MonoBehaviour
{
	public Material drawMat;

	// Use this for initialization
	void Start ()
	{
	
	}
	
	// Update is called once per frame
	void Update ()
	{
		if (Input.GetMouseButton (0)) {
			Vector3 pos = Input.mousePosition;
			pos.x /= Screen.width;
			pos.y /= Screen.height;
			pos.z = 6f;
			drawMat.SetVector ("_Draw", pos);
		} else
			drawMat.SetVector ("_Draw", Vector3.zero);
	}
}
