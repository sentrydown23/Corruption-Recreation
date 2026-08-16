import funkin.game.PlayState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var player = strumLines.members[1];
var opponent = strumLines.members[0];
var middle = strumLines.members[2];

function postCreate()
{
    offsetBF();
    offsetOpponent();
    offsetGF();

}

function offsetBF()
{
    player.characters[0].y += 120;
    player.characters[0].x += 100;
    player.characters[0].cameraOffset.y -= 20;
    player.characters[0].cameraOffset.x -= 80;
}

function offsetGF()
{
    middle.characters[0].x -= 50;
}

function offsetOpponent()
{

    opponent.characters[0].x -= 200;
    opponent.characters[0].cameraOffset.x += 60;
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration);
    }
    return null;
}