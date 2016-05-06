using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class ShaderManager : MonoBehaviour {

    GameObject[] actors;
     public Material[] materials;

     [SerializeField] Slider ActorSlider;

    Renderer[] actorRenderers;

    
    
	// Use this for initialization
	void Awake () {
        actors = GameObject.FindGameObjectsWithTag("Player");
        actorRenderers = new Renderer[actors.Length];
        for (int i = 0; i < actors.Length; i++)
			{
			    actorRenderers[i] = actors[i].GetComponent<Renderer>();
			}

        LoadMaterials();

        
	}

    void Update()
    {

       
       
        for (int i = 0; i < actorRenderers.Length; i++)
			{
                Debug.Log("Setting " + ActorSlider.value + " on " + actorRenderers[i].material.name);
			    actorRenderers[i].sharedMaterial.SetFloat("Value",ActorSlider.value);
                
                
			}

        
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
            //actors[i].GetComponent<Renderer>().material = mat;
            actors[i].GetComponent<Renderer>().sharedMaterial= mat;
        }
    }

    
}
