import openfl.filters.ShaderFilter;

var vignetteBloom:CustomShader;

function postCreate()
{
    vignetteBloom = new CustomShader("memoryleakbloom");
}

function stepHit(curStep:Int)
{
    switch(curStep)
    {
        case 780:
            camGame.addShader(vignetteBloom);
    }
}