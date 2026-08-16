var player = strumLines.members[1];
var opponent = strumLines.members[0];
var middle = strumLines.members[2];

function postCreate()
{
    offsetBF();
    offsetOpponent();
    offsetGF();

    player.characters[1].visible = false;
    player.characters[2].visible = false;
    opponent.characters[1].visible = false;
}

function beatHit(_)
{
    switch(_)
    {
        case 160:
            player.characters[0].visible = false;
            player.characters[1].visible = true;

        case 192:
            player.characters[1].visible = false;
            player.characters[0].visible = true;

        case 208:
            player.characters[0].visible = false;
            player.characters[2].visible = true;

        case 400:
            player.characters[2].visible = false;
            player.characters[1].visible = true;

        case 432:
            player.characters[1].visible = false;
            player.characters[0].visible = true;
            opponent.characters[0].visible = false;
            opponent.characters[1].visible = true;
    }
}

function offsetBF()
{
    player.characters[0].y += 130;
    player.characters[0].x += 100;
    player.characters[0].cameraOffset.y -= 20;
    player.characters[0].cameraOffset.x -= 80;

    player.characters[1].y += 120;
    player.characters[1].x += 75;
    player.characters[1].cameraOffset.y -= 20;
    player.characters[1].cameraOffset.x -= 80;

    player.characters[2].y += 85;
    player.characters[2].x += 100;
    player.characters[2].cameraOffset.y -= 20;
    player.characters[2].cameraOffset.x -= 80;

}

function offsetGF()
{
    middle.characters[0].x -= 50;
}

function offsetOpponent()
{

    opponent.characters[0].x -= 200;
    opponent.characters[0].cameraOffset.x += 60;
    opponent.characters[1].x -= 200;
    opponent.characters[1].cameraOffset.x += 60;
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration);
    }
    return null;
}