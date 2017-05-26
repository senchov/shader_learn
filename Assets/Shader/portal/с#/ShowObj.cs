using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowObj : MonoBehaviour
{
	[SerializeField] private float Radius = 1.0f;
	private void OnDrawGizmos ()
	{
		Gizmos.color = Color.red;
		Gizmos.DrawWireSphere (transform.position, Radius);
	}

}
