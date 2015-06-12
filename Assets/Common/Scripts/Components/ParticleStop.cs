using UnityEngine;
using System.Collections;

public class ParticleStop : MonoBehaviour
{
	public bool autoDestuct;
	// Use this for initialization
	void Start ()
	{
		GetComponent<ParticleSystem>().enableEmission = false;
	}

	void Update ()
	{
		if (autoDestuct && GetComponent<ParticleSystem>().particleCount == 0)
			Destroy (gameObject);
	}
}
