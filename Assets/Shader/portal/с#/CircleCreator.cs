using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CircleCreator : MonoBehaviour 
{
	[SerializeField] private float Radius;
	[SerializeField] private int SegmentAmount;
	[SerializeField] private GameObject ShowObj;
	[SerializeField] private float FluctSpeed = 1;
	[SerializeField] private FluctateSettings[] FluctSegments;
	[SerializeField][Range (0.0f,1.0f)] private float Volume = 1;
	[SerializeField] private bool IsFluct = false;
	[SerializeField] private int FluctIndex;
	[SerializeField] private Material DefaultMat;
	[SerializeField] private UVSettings UV;

	private float FluctRange;

	float StepAngle = 0;

	private List <GameObject> ObjList = new List<GameObject> ();

	private List<List<float>> RadiusLists = new List<List<float>> ();
	bool IsChangeFirst = false;
	bool IsChangeSecond = true;
	int FirstIndex = 0;
	int SecondIndex = 1;
	private int Dir = 1;
	private float UVbaseX;
	private float UVbaseY;

	private void Start () 
	{
		MakeCircle ();

		UVbaseX = UV.RightTop.x - UV.LeftBottom.x;
		UVbaseY = UV.RightTop.y - UV.LeftBottom.y;

		float fluctFrame = 0;
		float angle = 0;

		for (int i = 0; i < FluctSegments.Length; i++)
		{
			List<float> radiusList = new List<float> ();
			for (int j = 0; j < ObjList.Count; j++)
			{
//				if (i == 0)
//					radiusList.Add (FluctSegments [i].GetFluctValue (i,ref fluctFrame,ref uvList));
//				else
					radiusList.Add (FluctSegments [i].GetFluctValue (i,ref fluctFrame));
			}
			RadiusLists.Add (radiusList);
		}

		GameObject o = new GameObject ("op");

		MeshFilter filter = o.AddComponent <MeshFilter> () as MeshFilter;
		MeshRenderer rend = o.AddComponent <MeshRenderer>() as MeshRenderer;
		rend.material = DefaultMat;

		Mesh m = new Mesh ();
		List <Vector3> vect = new List<Vector3> ();
		List<Vector2> uvList = new List<Vector2> ();

		vect.Add (Vector3.zero);
		uvList.Add (GetUVCoord (vect[0]));

		for (int i = 0; i < ObjList.Count; i++)
		{			
			float radius =Volume * (RadiusLists [FirstIndex] [i] + Radius);

			vect.Add (new Vector3 (GetX (angle,radius), GetY (angle,radius), 0));
			uvList.Add (GetUVCoord (vect[i]));
			angle += StepAngle;
		}

		print (uvList[uvList.Count-3] + "  "+
			uvList[uvList.Count-2] + "  " +
			uvList[uvList.Count-1] + "  ");
		
			//uvList[uvList.Count-3] + "  ");

		m.SetVertices (vect);
		filter.mesh = m;

		m.SetUVs (0,uvList);

		int[] triangles = new int[ObjList.Count * 3];
		//triangles [0] = 0;
		int firstPoint = 1;
		int secondPoint = 2;

		for (int i = 0; i < triangles.Length-3; i++) 
		{
			if (i % 3 == 0)
				triangles [i] = 0;
			
			if ((i-1) % 3 == 0)
			{
				triangles [i] = firstPoint;
				firstPoint++;
			}
			if ((i-2) % 3 == 0)
			{
				triangles [i] = secondPoint;
				secondPoint++;
			}			
		}

		triangles[triangles.Length-3] = 0;
		triangles[triangles.Length-2] = secondPoint-1;
		triangles[triangles.Length-1] = 1;
		print ("v->" + vect.Count + " uv->" + uvList.Count + " tr->" + triangles.Length);
		m.triangles = triangles;	
		m.RecalculateBounds ();
		m.RecalculateNormals ();

	}

	private void FixedUpdate () 
	{
		if (!IsFluct)
			return;
		
		float angle = 0;
		float fluctFrame = 0;
		for (int i = 0; i < ObjList.Count; i++)
		{			
			float radius =Volume * (RadiusLists [FirstIndex] [i]* (1 - FluctRange) + RadiusLists [SecondIndex][i]* FluctRange + Radius);

			ObjList [i].transform.localPosition = new Vector3 (GetX (angle,radius), GetY (angle,radius), 0);
			angle += StepAngle;
		}
		//print (FluctRange + " s-> " + IsChangeSecond + " f->" + IsChangeFirst);
		if ( IsChangeSecond && FluctRange > 0.99f) 
		{
			FirstIndex += 2;
			FirstIndex = (FirstIndex >=RadiusLists.Count-1) ? 0 : FirstIndex;
			IsChangeFirst = true;
			IsChangeSecond = false;
			Dir = -1;
		}

		if (IsChangeFirst && FluctRange < 0.01f ) 
		{
			SecondIndex += 2;
			SecondIndex = (SecondIndex >=RadiusLists.Count-1) ? 1 : SecondIndex;
			IsChangeSecond = true;
			IsChangeFirst = false;
			Dir = 1;
		}
		FluctRange += Time.deltaTime * FluctSpeed  * Dir;

	}


	[ContextMenu ("MakeCircle")]
	public void MakeCircle () 
	{
		StepAngle = 360.0f / (float) SegmentAmount;
		float angle = 0;
		for (int i = 0; i < SegmentAmount; i++) 
		{			
			ObjList.Add (GetObj (0 , 0));
		}
	}

	private float GetX (float angle, float radius,float centrX = 0)
	{
		float x = 0;
		x =  radius * Mathf.Sin (angle * Mathf.Deg2Rad) ;
		return x;
	}

	private float GetY (float angle, float radius, float centrY = 0)
	{
		float y = 0;
		y = radius * Mathf.Cos (angle * Mathf.Deg2Rad) ;
		return y;
	}

	private GameObject GetObj (float x, float y) 
	{
		GameObject obj = Instantiate (ShowObj) as GameObject;
		obj.transform.position = new Vector3 (x,y,0);
		obj.transform.SetParent (transform);
		return obj;
	}

	[ContextMenu ("ShowSegment")]
	public void ShowSegment () 
	{
		float angle = 0;
		float fluctFrame = 0;
		for (int i = 0; i < ObjList.Count; i++)
		{			
			float radius =Volume * (RadiusLists [FluctIndex] [i] + Radius);

			ObjList [i].transform.localPosition = new Vector3 (GetX (angle,radius), GetY (angle,radius), 0);
			angle += StepAngle;
		}
	}

	private List <Vector2> GetUVPoints (List <Vector3> vert)  
	{
		List <Vector2> uvList = new List<Vector2> ();
		return uvList;		
	} 

	private Vector2 GetUVCoord (Vector3 vertix) 
	{
		return new Vector2((vertix.x - UV.LeftBottom.x)/UVbaseX,(vertix.y - UV.LeftBottom.y)/UVbaseY);
	}

	[System.Serializable]
	private class FluctateSettings 
	{
		
		public int Start;
		public int End;
		public AnimationCurve FluctCurve;
		public float FluctSpeed;
		public float FluctOffset;
		public int RangeMover;

		private float GetFluctStep ()
		{
			return 1.0f/(End - Start);
		}

		public float GetFluctValue (int pointInCircle, ref float fluctFrame)
		{
			float value = 0;
			if ( pointInCircle>= (Start + RangeMover) && pointInCircle <=( End  + RangeMover))
			{
				value= this.FluctOffset * FluctCurve.Evaluate (fluctFrame);
				fluctFrame += GetFluctStep();
			}


			if (pointInCircle == End)
				fluctFrame = 0;
			return value;
		} 

		public float GetFluctValue (int pointInCircle, ref float fluctFrame, ref List <Vector2> uvList)
		{
			float value = 0;
			if ( pointInCircle>= (Start + RangeMover) && pointInCircle <=( End  + RangeMover))
			{
				value= this.FluctOffset * FluctCurve.Evaluate (fluctFrame);
				fluctFrame += GetFluctStep();
				uvList.Add (new Vector2 (fluctFrame,fluctFrame));
			}

			return value;
		}
	}

	[System.Serializable]
	private class UVSettings 
	{
		public Vector2 LeftBottom;
		public Vector2 RightTop;
	}

}
