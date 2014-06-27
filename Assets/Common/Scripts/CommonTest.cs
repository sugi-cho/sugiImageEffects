using UnityEngine;
using System.Collections;

public class CommonTest : MonoBehaviour
{
	public Bisection[] bs;
	public int index;
	public float targetVal = 0.5f;
	// Use this for initialization
	void Start ()
	{
		Bisection.SetBisectionVal (bs);
	}
	
	// Update is called once per frame
	void Update ()
	{
		index = Bisection.GetIndex (bs, targetVal);
	}
}
