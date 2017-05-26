using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class PointFluctuator : MonoBehaviour 
{
	[SerializeField] private RadiusSettings Radius;
	[SerializeField] private float Duration = 0.5f;
	[SerializeField] private int StartIndex;
	[SerializeField] private bool IsDisableMove = false;
	GameObject obj;
	private Vector3 StartPos;

	private void Start () 
	{
		StartPos = transform.position;
		Move ();
	}

	private void Move () 
	{
		if (!obj)
			Destroy (obj);

		float[] dirValues = {1,-1};
//		int xIndex = Random.Range (0,2);
//		int yIndex = Random.Range (0,2);

		float addx = (Radius.LockAxesX) ? 0 :  dirValues[StartIndex] * Random.Range (Radius.Min,Radius.Max);
		float addy = (Radius.LockAxesY) ? 0 : dirValues[StartIndex] * Random.Range (Radius.Min,Radius.Max);

		Vector3 target = new Vector3 (StartPos.x + addx,
			StartPos.y + addy,
			StartPos.z);
		StartIndex ++;
		StartIndex = (StartIndex == 2) ? 0 : StartIndex;

		if (!IsDisableMove)
			transform.DOMove (target, Duration).OnComplete (Move);
		else 
		{
			 obj = GameObject.CreatePrimitive (PrimitiveType.Cube);
			obj.transform.DOMove (target, Duration).OnComplete (Move);
		}
	}

	private void OnDrawGizmos () 
	{
		Gizmos.color = Color.green;
		Gizmos.DrawWireSphere (StartPos,Radius.Max);
	}

	[System.Serializable]
	private class RadiusSettings 
	{
		public float Min;
		public float Max;
		public bool LockAxesX;
		public bool LockAxesY; 
	}
}
