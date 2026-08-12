import funkin.game.PlayState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var player = strumLines.members[1];
var opponent = strumLines.members[0];
var middle = strumLines.members[2];

function postCreate()
{
    offsetBF();
    offsetGF();
    offsetOpponent();
}

function offsetBF()
{
    player.characters[0].y += 150;
    player.characters[0].cameraOffset.x -= 200;
    player.characters[0].cameraOffset.y -= 50;
}

function offsetGF()
{
    middle.characters[0].x -= 150;
}

function offsetOpponent()
{
    opponent.characters[0].y += 230;
    opponent.characters[0].cameraOffset.y += 50;
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration);
    }
    return null;
}