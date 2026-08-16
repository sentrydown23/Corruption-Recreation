import funkin.game.PlayState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var player = strumLines.members[1].characters;
var opponent = strumLines.members[0].characters;
var middle = strumLines.members[2].characters;

var evilSpooky:Bool = false;

function postCreate()
{
    offsetOpponent();
	opponent[1].visible = false;
}

function stepHit(curStep:Int) // Using stepHit for precision 
{
	switch(curStep)
	{
		case 279, 280, 281, 282, 283, 285, 286, 289, 311, 312, 313, 314, 315, 316, 318:
			evilSpookyStage();
		
		case 321, 393, 401, 445, 449, 513, 515, 516, 518, 519, 521, 541, 545, 657, 669, 779, 780:
			evilSpookyStage();

		case 780, 781, 785, 803, 804, 805, 809, 897, 898, 899, 900, 901, 902, 903, 904, 905, 906:
			evilSpookyStage();

		case 963, 977, 988, 993, 1041, 1049, 1050, 1053, 1054, 1055, 1056, 1057, 1079, 1087, 1088, 1089:
			evilSpookyStage();
	}
}

function offsetBF()
{
	player[0].x -= 15;
}

function offsetGF()
{
	middle[0].x -= 150;
}

function offsetOpponent()
{
	opponent[1].cameraOffset.y += 100;
    opponent[1].cameraOffset.x += 65;
}

function evilSpookyStage()
{
	evilSpooky = !evilSpooky;
	opponent[0].alpha   = evilSpooky ? 0 : 1;
	middle[0].visible   = !evilSpooky;
	opponent[1].visible = evilSpooky;
}


function tweenTo(object:Dynamic, values:Dynamic, duration:Float) {
	if (object != null) {
		FlxTween.globalManager.cancelTweensOf(object);
		return FlxTween.tween(object, values, duration);
	}
	return null;
}