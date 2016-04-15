using UnityEngine;
using System.Collections;

public class SpriteAnimator : MonoBehaviour {

    public Sprite[] sprites;
    public float animSpeed;
    SpriteRenderer sr;
    int curSprite;

    IEnumerator HandleSprites() {

        do
        {
            curSprite++;
            if(curSprite>sprites.Length-1)
                curSprite = 0;
            sr.sprite = sprites[curSprite];
            yield return new WaitForSeconds(animSpeed);
        }
        while (true);
    }

	// Use this for initialization
	void Start () {
        sr = GetComponent<SpriteRenderer>();
        curSprite = 0;
        StartCoroutine(HandleSprites());
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
