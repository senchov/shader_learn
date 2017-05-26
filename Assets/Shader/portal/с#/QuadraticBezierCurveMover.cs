using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class QuadraticBezierCurveMover : MonoBehaviour 
{
	[SerializeField] private Transform MoveObject;
	[SerializeField] private AnimationCurve Curve;

	[SerializeField] private float FlyTime;
	[SerializeField][Range (0,1)] private float Distance;
	[SerializeField] private MovePoints Points;

	[SerializeField] public UnityEvent OnMoveStart;
	[SerializeField] public UnityEvent OnMoveComplete;

//	private void Update ()
//	{
//		MoveObject.transform.localPosition = GetCurvePoint (Distance, Points.Start.localPosition,
//			Points.Controll.localPosition, Points.End.localPosition);
//	}

	[ContextMenu ("Move")]
	public void Move ()
	{
		Move (FlyTime,Points.Start.localPosition,Points.Controll.localPosition,Points.End.localPosition);
	}

	public void Move (float time, Vector3 start,Vector3 controll, Vector3 end)
	{
		
		StartCoroutine (MoveTarget (time,start,controll,end));
	}

	private IEnumerator MoveTarget (float time,Vector3 start,Vector3 controll, Vector3 end) 
	{
		if (time == 0)
			yield break;

		OnMoveStart.Invoke ();
		float moveTime = 0;
		while (moveTime < time)
		{			
			float distance = moveTime / time;
			moveTime += Time.deltaTime * Curve.Evaluate(moveTime);
			MoveObject.transform.localPosition = GetCurvePoint (distance, start,
				controll, end);
			yield return null;
		}
		OnMoveComplete.Invoke ();
	}

	private Vector3 GetCurvePoint (float t, Vector3 start,Vector3 controll, Vector3 target) 
	{
		t = Mathf.Clamp (t, 0, 1);
		Vector3 curvePoint = Vector3.zero;
		curvePoint.x = (1 - t) * (1 - t) * start.x + 2 * (1 - t) * t * controll.x + t * t * target.x;
		curvePoint.y = (1 - t) * (1 - t) * start.y + 2 * (1 - t) * t * controll.y + t * t * target.y;
		curvePoint.z = Mathf.Lerp (start.z, target.z, t);
		return curvePoint;
	}

	private void OnDrawGizmos () 
	{
		Gizmos.color = Color.yellow;
		float radius = 0.1f;
		Gizmos.DrawWireSphere ( Points.Start.position , radius);
		Gizmos.DrawWireSphere (GetCurvePoint (0.1f, Points.Start.position, Points.Controll.position, Points.End.position), radius);
		Gizmos.DrawWireSphere (GetCurvePoint (0.2f, Points.Start.position, Points.Controll.position, Points.End.position), radius);
		Gizmos.DrawWireSphere (GetCurvePoint (0.3f, Points.Start.position, Points.Controll.position, Points.End.position), radius);
		Gizmos.DrawWireSphere (GetCurvePoint (0.4f, Points.Start.position, Points.Controll.position, Points.End.position), radius);
		Gizmos.DrawWireSphere (GetCurvePoint (0.5f, Points.Start.position, Points.Controll.position, Points.End.position), radius);
		Gizmos.DrawWireSphere (GetCurvePoint (0.6f, Points.Start.position, Points.Controll.position, Points.End.position), radius);
		Gizmos.DrawWireSphere (GetCurvePoint (0.7f, Points.Start.position, Points.Controll.position, Points.End.position), radius);
		Gizmos.DrawWireSphere (GetCurvePoint (0.8f, Points.Start.position, Points.Controll.position, Points.End.position), radius);
		Gizmos.DrawWireSphere (GetCurvePoint (0.9f, Points.Start.position, Points.Controll.position, Points.End.position), radius);
		Gizmos.DrawWireSphere ( Points.End.position , radius);
	}

	[System.Serializable]
	private class MovePoints 
	{
		public Transform Start;
		public Transform Controll;
		public Transform End;
	}

}
