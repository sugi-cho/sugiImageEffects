using UnityEngine;
using System.Collections;

public class ShowSpline : MonoBehaviour
{
	public float t;
	public Spline spline;
	
	// Use this for initialization
	void Start ()
	{
	
	}
	
	// Update is called once per frame
	void Update ()
	{
	
	}
	
	void OnDrawGizmos ()
	{
		if (spline.points == null)
			spline.points = new Vector3[4];
		Spline.DrawPathHelper (spline.points, Color.white);
		
		t = (t + 0.1f) % 1f;
		Gizmos.color = Color.red;
		Gizmos.DrawSphere (spline.GetPoint (t), 0.1f);
	}
}
