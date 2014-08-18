using UnityEngine;
using UnityEditor;
using System.Collections;

public class ImportSetting : AssetPostprocessor
{

	public override int GetPostprocessOrder ()
	{
		return 0;
	}

	void OnPreprocessModel ()
	{
		ModelImporter importer = assetImporter as ModelImporter;

		importer.animationType = ModelImporterAnimationType.None;
		importer.importMaterials = false;
		importer.normalImportMode = ModelImporterTangentSpaceMode.Calculate;
//		importer.normalSmoothingAngle = 180f;
	}
}
