using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class ActorDropdown : MonoBehaviour {

    ShaderManager sm;
    [SerializeField] Dropdown d;

    void Awake() {
        sm = GameObject.FindObjectOfType<ShaderManager>();
        d = GetComponent<Dropdown>();
    }

    public void UpdateValues() {

        Debug.Log("Updating values");

        d.ClearOptions();

        for (int i = 0; i < sm.materials.Length; i++)
			{
                d.options.Add(new Dropdown.OptionData(sm.materials[i].name));
			}
        
    
    
    }

    public void OnDropDownChange() {

        sm.ApplyMaterial( sm.materials[  d.value]);
    
    }
}
