using UnityEngine;
using System.Collections;

public class ShowFPS : MonoBehaviour
{
	int
		count = 0,
		fps;
	float perDeltaTime;
	// Use this for initialization
	void Start ()
	{
		InvokeRepeating ("Show", 1f, 1f);
	}
	
	// Update is called once per frame
	void Update ()
	{
		perDeltaTime = 1f / Time.deltaTime;
	}

	void Show ()
	{
		fps = Time.frameCount - count;
		count = Time.frameCount;
	}

	void OnGUI ()
	{
		GUI.Label (Rect.MinMaxRect (0, 0, 100f, 20f), "FPS:" + fps.ToString ());
		GUI.Label (Rect.MinMaxRect (0, 20f, 100f, 40f), "1/deltaTime:" + perDeltaTime.ToString ());
	}
}
