using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CustomImageEffect : MonoBehaviour 
{
	[SerializeField] Material EffectMat;

	private void OnRenderImage (RenderTexture src, RenderTexture dst) 
	{
		if (EffectMat != null)
			Graphics.Blit (src, dst, EffectMat);
	}


	private void Update () 
	{
		float op = Mathf.Sin (Time.time) * 0.01f;
		print (op);
		//sEffectMat.SetFloat ("_OutMagnitude" , op);
	}
}
