using UnityEngine;
using System.Collections;

public class SetInstantiateTime : MonoBehaviour
{
	Material m;
	// Use this for initialization
	void Start ()
	{
		m = GetComponent<Renderer>().material;
		m.SetFloat ("_T", Time.time);
	}
	void OnDestroy ()
	{
		if (m != null)
			Destroy (m);
	}
}