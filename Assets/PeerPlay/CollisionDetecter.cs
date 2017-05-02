using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionDetecter : MonoBehaviour 
{
	[SerializeField] private float DistanceX;
	[SerializeField] private float DistanceZ;
	[SerializeField] private float MagnitudeDivider;
	[SerializeField] private float[] WaveAmplitude;
	[SerializeField] private Vector2[] ImpactPosition;
	[SerializeField] private float[] Distance;
	[SerializeField] private float SpeadWaveSpread;
	private int WaveNumber;

	Mesh PlaneMesh;
	Renderer MyRenderer;

	private void Start ()
	{
		PlaneMesh = GetComponent <MeshFilter> ().mesh;
		MyRenderer = GetComponent <Renderer> ();
		for (int i = 0; i < 8; i++)
		{			
			MyRenderer.material.SetFloat ("_WaweAmplitude" + (i+1), 0);
		}
	}

	private void Update () 
	{
		for (int i = 0; i < 8; i++)
		{
			WaveAmplitude [i] = MyRenderer.material.GetFloat ("_WaweAmplitude" + (i+1));
			if (WaveAmplitude [i] > 0) 
			{
				Distance [i] += SpeadWaveSpread;
				MyRenderer.material.SetFloat ("_Distance" + (i +1),Distance [i]);
				MyRenderer.material.SetFloat ("_WaweAmplitude" + (i+1), WaveAmplitude[i] * 0.98f);
			}

			if (WaveAmplitude [i] <  0.05f) 
			{
				MyRenderer.material.SetFloat ("_WaweAmplitude" + (i+1), 0);
				Distance [i] = 0;
			}

		}
	}

	void OnCollisionEnter (Collision col) 
	{
		if (col.rigidbody) 
		{
			WaveNumber++;
			WaveNumber = (WaveNumber == 9) ? 1 : WaveNumber;
			WaveAmplitude [WaveNumber - 1] = 0;
			Distance [WaveNumber - 1] = 0;

			DistanceX = this.transform.position.x - col.transform.position.x;
			DistanceZ = this.transform.position.z - col.transform.position.z;
			ImpactPosition [WaveNumber - 1].x = col.transform.position.x;
			ImpactPosition [WaveNumber - 1].y = col.transform.position.z;

			MyRenderer.material.SetFloat ("_xImpact" + WaveNumber, col.transform.position.x);
			MyRenderer.material.SetFloat ("_zImpact" + WaveNumber, col.transform.position.z);

			MyRenderer.material.SetFloat ("_Offsetx" + WaveNumber,DistanceX / PlaneMesh.bounds.size.x * 2.5f);
			MyRenderer.material.SetFloat ("_Offsetz" + WaveNumber,DistanceZ / PlaneMesh.bounds.size.z * 2.5f);

			MyRenderer.material.SetFloat ("_WaweAmplitude" + WaveNumber
				,col.rigidbody.velocity.magnitude * MagnitudeDivider);
		}
	}
}
