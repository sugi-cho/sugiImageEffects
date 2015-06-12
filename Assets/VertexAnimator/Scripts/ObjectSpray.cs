using UnityEngine;
using System.Collections;

public class ObjectSpray : MonoBehaviour {
	public Transform t;
	public float length = 5f;
	public float radius = 1f;
	
	// Update is called once per frame
	void Update () {
		if(Input.GetMouseButton(0)){
			Vector3 mousePos = Input.mousePosition;
			Vector2 sprayPos = Random.insideUnitCircle*radius;
			mousePos.x += sprayPos.x;
			mousePos.y += sprayPos.y;
			mousePos.z = length;
			Transform trans = ((Transform)Instantiate(t, GetComponent<Camera>().ScreenToWorldPoint(mousePos),t.rotation));
			trans.gameObject.AddComponent<Time2Destroy>().time = 30f;
			trans.LookAt(transform.position, Random.onUnitSphere);
		}
	}
}
