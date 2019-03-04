using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConstantRotate : MonoBehaviour
{

    public float rotateSpeed = 180;

    // Update is called once per frame
    void Update()
    {
        transform.rotation *= Quaternion.Euler(0, Time.deltaTime * rotateSpeed, 0);
    }
}
