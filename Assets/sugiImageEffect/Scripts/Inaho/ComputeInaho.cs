using UnityEngine;
using System.Collections;

public class ComputeInaho : MonoBehaviour
{

	public RenderTexture
		forceTex,
		velocityTex,
		inclinationTex;
	public int
		width = 512,
		height = 512;
	public Material
		forceMat,
		velMat,
		inclMat,
		forceInit,
		velInit,
		inclInit;
	public float fps = 30f;

	public Material targetMat;
	public string propName = "_TilTex";


	// Use this for initialization
	void Start ()
	{
		forceTex = new RenderTexture (width, height, 0, RenderTextureFormat.ARGBHalf);
		velocityTex = new RenderTexture (width, height, 0, RenderTextureFormat.ARGBHalf);
		inclinationTex = new RenderTexture (width, height, 0, RenderTextureFormat.ARGBHalf);
		
		forceTex.Create ();
		velocityTex.Create ();
		inclinationTex.Create ();

		forceInit.Render (forceTex);
		velInit.Render (velocityTex);
		inclInit.Render (inclinationTex);

		InvokeRepeating ("Compute", 1f / fps, 1f / fps);
	}
	
	// Update is called once per frame
	void Compute ()
	{
		velMat.SetTexture ("_Force", forceTex);
		velMat.SetTexture ("_MainTex", velocityTex);
		velMat.SetTexture ("_InclTex", inclinationTex);
		velMat.Render (velocityTex);
		forceInit.Render (forceTex);
		inclMat.SetTexture ("_MainTex", inclinationTex);
		inclMat.SetTexture ("_VelTex", velocityTex);
		inclMat.Render (inclinationTex);
		if (renderer != null)
			renderer.material.mainTexture = inclinationTex;
		if (targetMat != null)
			targetMat.SetTexture (propName, inclinationTex);
	}
	
	public void AddForce (Vector2 pos, Vector2 vel, Material force = null)
	{
		Vector4 prop = new Vector4 (pos.x, pos.y, vel.x, vel.y);
		if (force != null)
			forceMat = force;
		forceMat.SetFloat ("_Power", vel.magnitude * 500f);
		forceMat.SetVector ("_Prop", prop);
		forceMat.Render (forceTex);
//		renderer.material.mainTexture = forceTex;
		velMat.SetTexture ("_Force", forceTex);
	}

	Vector2 
		prePos,
		preVel;
	void Update ()
	{
		if (!Input.GetMouseButton (0))
			return;
		Vector2 mPos = Input.mousePosition.XY ();
		mPos.x /= Screen.width;
		mPos.y /= Screen.height;

		if (Input.GetMouseButtonDown (0)) {
			AddForce (mPos, Vector2.zero);
			prePos = mPos;
		} else if (Input.GetMouseButton (0)) {
			AddForce (mPos, mPos - prePos);
			prePos = mPos;
		}


//		Ray r = Camera.main.ScreenPointToRay (mPos);
//		RaycastHit hit;
//		if (Physics.Raycast (r, out hit)) {
//			if (hit.collider.gameObject == gameObject) {
//				Vector2
//				pos = hit.textureCoord,
//				vel = hit.textureCoord - prePos;
//				AddForce (pos, vel);
//				prePos = pos;
//				preVel = vel;
//			}
//		}
	}
}
