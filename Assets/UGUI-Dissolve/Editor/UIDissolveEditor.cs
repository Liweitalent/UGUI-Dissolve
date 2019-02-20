using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(UIDissolve))]
public class UIDissolveEditor : Editor
{
	float _range;
	float _width;
	float _softness;
	Vector2 _scale;

	Texture _noiseTexture;

	protected void OnEnable()
	{
		var tempTarget = target as UIDissolve;
		_range = tempTarget.Range;
		_width = tempTarget.Width;
		_softness = tempTarget.Softness;
		_scale = tempTarget.NoiseScale;
		_noiseTexture = tempTarget.NoiseTex;
	}

	public override void OnInspectorGUI()
	{
		var tempTarget = target as UIDissolve;

		GUILayout.Label("消融范围");
		_range = EditorGUILayout.Slider(_range,0,1);
		GUILayout.Label("消融宽度");
		_width = EditorGUILayout.Slider(_width, 0, 1);
		GUILayout.Label("消融虚化程度");
		_softness = EditorGUILayout.Slider(_softness, 0, 1);
		_scale = EditorGUILayout.Vector2Field("噪声XY数量", _scale);
		_noiseTexture = EditorGUILayout.ObjectField("噪声贴图",_noiseTexture,typeof(Texture)) as Texture;

		tempTarget.NoiseTex = _noiseTexture;
		tempTarget.Range = _range;
		tempTarget.Width = _width;
		tempTarget.Softness = _softness;
		tempTarget.NoiseScale = _scale;
	}
}
