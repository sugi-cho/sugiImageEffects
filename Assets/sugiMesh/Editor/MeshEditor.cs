using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class CubeParticle
{
	[MenuItem("sugi.cho/Create/ParticleMesh")]
	public static void CreateParticleMesh ()
	{
		foreach (var o in Selection.objects) {
			Mesh mesh = (Mesh)o;
			if (mesh != null) {
				CreateParticleFromMesh (mesh);
			}
		}
	}
	static void CreateParticleFromMesh (Mesh mesh)
	{
		int[] indices0 = mesh.GetIndices (0);

		int 
		vCount = mesh.vertexCount,
		iCount = indices0.Length,
		numParticles = Mathf.NextPowerOfTwo (65000 / vCount / 2);


		float log2 = Mathf.Log (numParticles, 2f);

		int
		numVerts = numParticles * vCount,
		numIndices = numParticles * iCount,
		numX = Mathf.FloorToInt (log2 / 2f),
		numY = (int)log2 - numX;

		numX = (int)Mathf.Pow (2f, numX);
		numY = (int)Mathf.Pow (2f, numY);

		Mesh newMesh = new Mesh ();
		int[] indices = new int[numIndices];

		Vector2[]
		uv1 = new Vector2[numVerts],
		uv2 = new Vector2[numVerts];

		Vector3[]
		vertices = new Vector3[numVerts];
//		normals = new Vector3[numVerts];

		for (int y = 0; y < numY; y++) {
			for (int x = 0; x < numX; x++) {
				int index = x + y * numX;
				for (int i = 0; i < vCount; i++) {
					vertices [index * vCount + i] = mesh.vertices [i];
					uv1 [index * vCount + i] = mesh.uv [i];
					uv2 [index * vCount + i] = new Vector2 ((float)x / (float)numX, (float)y / (float)numY);
				}
				for (int i = 0; i < iCount; i++)
					indices [index * iCount + i] = indices0 [i] + index * vCount;
			}
		}
		newMesh.vertices = vertices;
		newMesh.uv = uv1;
		newMesh.uv2 = uv2;
		newMesh.SetIndices (indices, MeshTopology.Triangles, 0);
		newMesh.RecalculateNormals ();
		newMesh.RecalculateBounds ();

		AssetDatabase.CreateAsset (newMesh, string.Format ("Assets/{0}_{1}_{2}_particle.asset", mesh.name, numX, numY));
		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();
	}
}
