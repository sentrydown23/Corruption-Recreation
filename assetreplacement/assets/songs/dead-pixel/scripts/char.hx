var player = strumLines.members[1].characters;
var opponent = strumLines.members[0].characters;
var middle = strumLines.members[2].characters;

var bfEvil:Int = 0;

function postCreate()
{
    offsetBF();
    offsetOpponent();   

    player[1].visible = false;
    player[2].visible = false;
    player[3].visible = false;

    opponent[1].visible = false;
}

function beatHit(_)
{
    switch(_)
    {
        case 16:
            bfIsEvil();

        case 32:
            bfIsEvil();

        case 40:
            bfIsEvil();

        case 156:
            opponent[0].visible = false;    
            opponent[1].visible = true;
    }
}

function offsetBF()
{
    player[1].x -= 15;
    player[2].x -= 30;
    player[3].x -= 55;
}

function offsetGF()
{
    middle[0].x -= 150;
}

function offsetOpponent()
{
    opponent[1].x -= 15;
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration);
    }
    return null;
}

function bfIsEvil()
{
    bfEvil += 1;

    if (bfEvil == 1) {
        player[0].visible = false;
        player[1].visible = true;
    }
    else if (bfEvil == 2) {
        player[1].visible = false;
        player[2].visible = true;
    }
    else if (bfEvil == 3) {
        player[2].visible = false;
        player[3].visible = true;
    }
}