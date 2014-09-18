using UnityEngine;
using System.Collections;

public class Time2Destroy : MonoBehaviour {
	public float time = 10f;
	// Use this for initialization
	void Awake(){
		Time2Destroy[] others = GetComponents<Time2Destroy>();
		if(others.Length == 1)
			return;
		Destroy(this);
	}
	void Start () {
		Destroy(gameObject, time);
	}
}
