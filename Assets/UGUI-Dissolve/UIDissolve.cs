using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class UIDissolve : MonoBehaviour
{
	public static string ShaderName = "UI/UI-Effect-Dissolve";

	[SerializeField]
	private Material _defaultMaterial = null;
	public Material defaultMaterial
	{
		get
		{
			if (_defaultMaterial == null)
			{
				_defaultMaterial =new Material(Shader.Find(ShaderName));
			}
			return _defaultMaterial;
		}
	}

	[SerializeField]
	private Graphic[] _graphics;

	public Graphic[] Graphics
	{
		get
		{
			if (_graphics == null)
			{
				_graphics = GetComponentsInChildren<Graphic>();
			}
			return _graphics;
		}
	}

	[SerializeField]
	private float _range;
	public float Range
	{
		get { return _range; }
		set
		{
			_range = value;
			defaultMaterial.SetFloat("_DissolveRange", _range);
		}
	}

	[SerializeField]
	private float _width;
	public float Width
	{
		get { return _width; }
		set
		{
			_width = value;
			defaultMaterial.SetFloat("_DissolveWidth", _width);
		}
	}

	[SerializeField]
	private float _softness;
	public float Softness
	{
		get { return _softness; }
		set
		{
			_softness = value;
			defaultMaterial.SetFloat("_DissolveSoftness", _softness);
		}
	}

	[SerializeField]
	private Vector2 noiseScale;
	public Vector2 NoiseScale
	{
		get { return noiseScale; }
		set
		{
			noiseScale = value;
			defaultMaterial.SetTextureScale("_NoiseTex", noiseScale);
		}
	}

	[SerializeField]
	private Texture noiseTex;
	public Texture NoiseTex
	{
		get { return noiseTex; }
		set
		{
			noiseTex = value;
			defaultMaterial.SetTexture("_NoiseTex", noiseTex);
		}
	}
	
	private Material[] oldMats;

	void OnEnable()
	{
		_range = defaultMaterial.GetFloat("_DissolveRange");
		_width = defaultMaterial.GetFloat("_DissolveWidth");
		_softness = defaultMaterial.GetFloat("_DissolveSoftness");
		noiseTex = defaultMaterial.GetTexture("_NoiseTex");
		if (noiseTex == null)
		{
			NoiseTex = GetComponent<DefaultNoise>().Noise;
		}
		noiseScale = defaultMaterial.GetTextureScale("_NoiseTex");
		oldMats = new Material[Graphics.Length];
		for(int i=0;i< Graphics.Length;i++)
		{
			oldMats[i] = Graphics[i].material;
			Graphics[i].material = defaultMaterial;
		}
	}

	void OnDisable()
	{
		for (int i = 0; i < Graphics.Length; i++)
		{
			Graphics[i].material=oldMats[i];
		}
	}
}
