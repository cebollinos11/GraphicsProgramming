using UnityEngine;
using System.Collections;

public class ShaderManager : MonoBehaviour {

    GameObject[] actors;
     public Material[] materials;
    
	// Use this for initialization
	void Awake () {
        actors = GameObject.FindGameObjectsWithTag("Player");
        LoadMaterials();

        
	}

    void Start()
    {

        //update gui
        GameObject.FindObjectOfType<ActorDropdown>().UpdateValues();
    }

    void LoadMaterials()
    {
        Object[] obj_materials = Resources.LoadAll("ActorMaterials/");

        materials = new Material[obj_materials.Length];

        for (int i = 0; i < obj_materials.Length; i++)
			{
                materials[i] = obj_materials[i] as Material;
			}
       
    }

    public void ApplyMaterial(Material mat) {
        for (int i = 0; i < actors.Length; i++)
        {
            actors[i].GetComponent<Renderer>().material = mat;
        }
    }

    
}
