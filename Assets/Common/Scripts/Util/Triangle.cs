using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Triangle
{
	public static Triangle[] GetTriangles (Mesh m, out Bisection[] bs)
	{
		Vector3[] vertices = m.vertices;
		int[] triangles = m.triangles;

		List<Bisection> bList = new List<Bisection> ();
		List<Triangle> tList = new List<Triangle> ();
		
		for (int i = 0; i < triangles.Length/3; i++) {
			Triangle t = new Triangle (vertices [triangles [i * 3]], vertices [triangles [i * 3 + 1]], vertices [triangles [i * 3 + 2]]);
			tList.Add (t);
			bList.Add (new Bisection (t.area));
		}
		bs = bList.ToArray ();
		Bisection.SetBisectionVal (bs);
		return tList.ToArray ();
	}

	//this is example code!!
	public static Triangle GetRandomTriangle (Triangle[] ts, Bisection[] bs)
	{
		return ts [Bisection.GetIndex (bs, Random.value)];
	}
	
	Vector3 point1, point2, point3;
	public float area;
	public Vector3 center, normal;
	Bisection b;
	
	public Triangle (Vector3 p1, Vector3 p2, Vector3 p3)
	{
		point1 = p1;
		point2 = p2;
		point3 = p3;
		
		Vector3 cross = Vector3.Cross (point2 - point1, point3 - point1);
		area = cross.magnitude / 2f;
		
		center = (point1 + point2 + point3) / 3f;
		normal = cross.normalized;
		
	}
	
	public Vector3 RandomPoint ()
	{
		Vector3
		p1 = Vector3.Lerp (point1, point2, Mathf.Sqrt (Random.value)),
		p2 = Vector3.Lerp (point1, point3, Mathf.Sqrt (Random.value));
		return Vector3.Lerp (p1, p2, Random.value);
	}
}