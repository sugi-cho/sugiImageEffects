using UnityEngine;
using UnityEditor;
using System.Collections;

public class MenuItems
{
	[MenuItem("sugi.cho/Window/Perlin3D")]
	public static void P3DWindow ()
	{
		CreateTex3D.Init ();
	}
}
