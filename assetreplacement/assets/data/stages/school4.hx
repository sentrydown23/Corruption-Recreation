var bgParts:Array<FlxSprite> = [];

var bgAnimated:Bool = false;

function postCreate()
{
    bgParts.push(bg1);
    bgParts.push(bg2);
    bgParts[1].visible = false;
}

function beatHit(_)
{
    switch(_)
    {
        case 128, 160, 224, 288, 320, 352:
            animateBG();
    }
}

function animateBG()
{
    if (!bgAnimated) {
        bgParts[1].visible = true;
        bgParts[0].visible = false;
        bgAnimated = true;
    }
    else if (bgAnimated)
    {
        bgParts[1].visible = false;
        bgParts[0].visible = true;
        bgAnimated = false;
    }
}