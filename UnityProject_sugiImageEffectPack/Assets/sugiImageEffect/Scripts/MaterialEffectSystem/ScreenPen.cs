using UnityEngine;
using System.Collections;

public class ScreenPen : MonoBehaviour
{
	public float
		brushSize = 1f,
		intencity = 0.5f;
	Draw2Texture draw;

	// Use this for initialization
	void Start ()
	{
		draw = GetComponent<Draw2Texture> ();
	}
	
	// Update is called once per frame
	void Update ()
	{
		float
		mx = Input.mousePosition.x / Screen.width,
		my = Input.mousePosition.y / Screen.height;

		if (Input.GetMouseButtonDown (0)) {
			Vector4 prop = new Vector4 (mx, my, brushSize, intencity);
			draw.PenDown (prop);
		} else if (Input.GetMouseButton (0)) {
			Vector4 prop = new Vector4 (mx, my, brushSize, intencity);
			draw.PenDraw (prop);
		}
		if (Input.GetMouseButtonUp (0)) {
			Vector4 prop = new Vector4 (mx, my, brushSize, intencity);
			draw.PenUp (prop);
		}
	}
}