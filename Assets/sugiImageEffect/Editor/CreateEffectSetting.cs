//using UnityEngine;
//using UnityEditor;
//using System.IO;
//using System.Collections;
//using System.Collections.Generic;
//
//public class CreateEffectSetting : EditorWindow
//{
//	[MenuItem("Window/EffectSetting")]
//	static void Init ()
//	{
//		EditorWindow.GetWindow (typeof(CreateEffectSetting));
//	}
//
//	[MenuItem("Custom/Create Effect")]
//	static void CreateEffect ()
//	{
//		EffectSetting effect = ScriptableObject.CreateInstance<EffectSetting> ();
//		AssetDatabase.CreateAsset (effect, "Assets/effect.asset");
//		AssetDatabase.SaveAssets ();
//		AssetDatabase.Refresh ();
//	}
//
//	static void CreateEffect (Material mat)
//	{
//		EffectSetting effect = ScriptableObject.CreateInstance<EffectSetting> ();
//		effect.effectMat = mat;
//		AssetDatabase.CreateAsset (effect, "Assets/" + mat.name + "Effect.asset");
//		AssetDatabase.SaveAssets ();
//		AssetDatabase.Refresh ();
//	}
//
//	Vector2 scrollPos;
//
//	void OnGUI ()
//	{
//		scrollPos = EditorGUILayout.BeginScrollView (scrollPos);
//		EditorGUILayout.BeginVertical ();
//		foreach (EffectSetting setting in GetAssetsOfType(typeof(EffectSetting), ".asset"))
//			EffectSettingGUI (setting);
//
//		EditorGUILayout.EndVertical ();
//		EditorGUILayout.Space ();
//		Material m = EditorGUILayout.ObjectField ("Create Effect:", null, typeof(Material), false) as Material;
//		if (m != null)
//			CreateEffect (m);
//		EditorGUILayout.EndScrollView ();
//
//	}
//
//	void EffectSettingGUI (EffectSetting setting)
//	{
//		EditorGUILayout.Space ();
//		EditorGUILayout.ObjectField (setting.name, setting, typeof(EffectSetting), false);
//		EditorGUI.indentLevel ++;
//		Material m = EditorGUILayout.ObjectField ("Effect Material: ", setting.effectMat, typeof(Material), false) as Material;
//		ShowMaterialEditor (m);
//		if (m != setting.effectMat) {
//			Undo.RecordObject (setting, "Change Setting");
//			setting.effectMat = m;
//		}
//		int iterate = EditorGUILayout.IntField ("Iterations:", setting.iterate);
//		if (iterate != setting.iterate) {
//			Undo.RecordObject (setting, "Change Setting");
//			setting.iterate = iterate;
//		}
//		if (setting.targetMats != null) {
//			for (int i = 0; i < setting.targetMats.Length; i++) {
//				Material mat = setting.targetMats [i];
//				EditorGUILayout.ObjectField ("Target" + i.ToString ("00"), mat, typeof(Material), false);
//			}
//		}
//		string s = EditorGUILayout.TextField ("Prop Name:", setting.targetPropName);
//		if (s != setting.targetPropName) {
//			Undo.RecordObject (setting, setting.name);
//			setting.targetPropName = s;
//		}
//
//		if (setting.output != null)
//			EditorGUILayout.ObjectField ("Out Put Texture(" + setting.output.wrapMode.ToString () + "):", setting.output, typeof(Texture), false);
//		EditorGUI.indentLevel --;
//	}
//
//	void ShowMaterialEditor (Material m)
//	{
//		if (m == null)
//			return;
//		if (!m.shader.isSupported)
//			return;
//		if (m == null) {
//			GUILayout.Label ("shader error");
//			return;
//		}
//		Shader s = m.shader;
//		EditorGUILayout.LabelField (m.name);
//		EditorGUI.indentLevel++;
//		
//		for (int j = 0; j < ShaderUtil.GetPropertyCount(s); j++) {
//			string propName = ShaderUtil.GetPropertyName (s, j);
//			string descript = ShaderUtil.GetPropertyDescription (s, j) + ":";
//			object preVal;
//			object val;
//		
//			switch (ShaderUtil.GetPropertyType (s, j)) {
//			case  ShaderUtil.ShaderPropertyType.Range:
//				EditorGUILayout.BeginHorizontal ();
//				float min = ShaderUtil.GetRangeLimits (s, j, 1);
//				float max = ShaderUtil.GetRangeLimits (s, j, 2);
//				preVal = m.GetFloat (propName);
//				val = EditorGUILayout.Slider (descript, (float)preVal, min, max);
//				if (val != preVal) {
//					Undo.RecordObject (m, m.name);
//					m.SetFloat (propName, (float)val);
//				}
//				EditorGUILayout.EndHorizontal ();
//				break;
//			case ShaderUtil.ShaderPropertyType.Float:
//				preVal = m.GetFloat (propName);
//				val = EditorGUILayout.FloatField (descript, (float)preVal);
//				if (val != preVal) {
//					Undo.RecordObject (m, m.name);
//					m.SetFloat (propName, (float)val);
//				}
//				break;
//			case ShaderUtil.ShaderPropertyType.Color:
//				preVal = m.GetColor (propName);
//				val = EditorGUILayout.ColorField (descript, (Color)preVal);
//				if (val != preVal) {
//					Undo.RecordObject (m, m.name);
//					m.SetColor (propName, (Color)val);
//				}
//				break;
//			case ShaderUtil.ShaderPropertyType.TexEnv:
//				preVal = m.GetTexture (propName);
//				val = EditorGUILayout.ObjectField (descript, (Texture)preVal, typeof(Texture), false);
//				if (val != preVal) {
//					Undo.RecordObject (m, m.name);
//					m.SetTexture (propName, (Texture)val);
//				}
//				break;
//			case ShaderUtil.ShaderPropertyType.Vector:
//				preVal = m.GetVector (propName);
//				val = EditorGUILayout.Vector4Field (descript, (Vector4)preVal);
//				if (val != preVal) {
//					Undo.RecordObject (m, m.name);
//					m.SetVector (propName, (Vector4)val);
//				}
//				break;
//			}
//		}
//		EditorGUI.indentLevel--;
//	}
//
//	/// <summary>
//	/// Used to get assets of a certain type and file extension from entire project
//	/// </summary>
//	/// <param name="type">The type to retrieve. eg typeof(GameObject).</param>
//	/// <param name="fileExtension">The file extention the type uses eg ".prefab".</param>
//	/// <returns>An Object array of assets.</returns>
//	public static Object[] GetAssetsOfType (System.Type type, string fileExtension)
//	{
//		List<Object> tempObjects = new List<Object> ();
//		DirectoryInfo directory = new DirectoryInfo (Application.dataPath);
//		FileInfo[] goFileInfo = directory.GetFiles ("*" + fileExtension, SearchOption.AllDirectories);
//	
//		int goFileInfoLength = goFileInfo.Length;
//		FileInfo tempGoFileInfo;
//		string tempFilePath;
//		Object tempGO;
//		for (int i = 0; i < goFileInfoLength; i++) {
//			tempGoFileInfo = goFileInfo [i];
//			if (tempGoFileInfo == null)
//				continue;
//		
//			tempFilePath = tempGoFileInfo.FullName;
//			tempFilePath = tempFilePath.Replace (@"\", "/").Replace (Application.dataPath, "Assets");
//		
//			Debug.Log (tempFilePath + "\n" + Application.dataPath);
//		
//			tempGO = AssetDatabase.LoadAssetAtPath (tempFilePath, typeof(Object)) as Object;
//			if (tempGO == null) {
//				Debug.LogWarning ("Skipping Null");
//				continue;
//			} else if (tempGO.GetType () != type) {
//				Debug.LogWarning ("Skipping " + tempGO.GetType ().ToString ());
//				continue;
//			}
//		
//			tempObjects.Add (tempGO);
//		}
//	
//		return tempObjects.ToArray ();
//	}
//}
