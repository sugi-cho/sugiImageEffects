using UnityEngine;
using System.Collections;

static class Extentions
{

	public static Vector2 XY (this Vector3 vec3)
	{
		return new Vector2 (vec3.x, vec3.y);
	}
	public static Vector2 YZ (this Vector3 vec3)
	{
		return new Vector2 (vec3.y, vec3.z);
	}
	public static Vector2 ZX (this Vector3 vec3)
	{
		return new Vector2 (vec3.z, vec3.x);
	}
}
