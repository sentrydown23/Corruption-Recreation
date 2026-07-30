import funkin.game.PlayState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var player = strumLines.members[1];
var opponent = strumLines.members[0];
var middle = strumLines.members[2];

function postCreate()
{
    // 0 = Monster
    // 1 = BF
    // 2 = GF

    offsetBF();
    offsetMonster();
    middle.characters[0].x -= 100;

    player.characters[1].visible = false;
    player.characters[2].visible = false;
    player.characters[3].visible = false;

    opponent.characters[1].visible = false;
    boyfriend.iconColor = 0xFF4B9CA9;
}

function beatHit(_)
{
    switch (_)
    {
        case 80:
            BFSwap(1);

        case 178:
            BFSwap(2);

        case 210:
            // make sure bfs are hidden
            player.characters[0].visible = false;
            player.characters[1].visible = false;

        case 212:
            middle.characters[0].visible = false;
            opponent.characters[0].visible = false;
            opponent.characters[1].visible = true;
            player.characters[2].visible = false;
            player.characters[3].visible = true;

        case 216, 220, 224, 228, 256, 260:
            headFade(false);

        case 242, 244, 267, 268:
            headFade(true); 

        case 274:
            opponent.characters[1].visible = false;
            player.characters[3].visible = false;
            opponent.characters[0].visible = true;
            middle.characters[0].visible = true;
            player.characters[2].visible = true;

        case 342:
            BFSwap(3);

        case 406:
            BFSwap(4);
    }
}

function BFSwap(number:Int) 
{

    if (number == 1) {
        player.characters[0].animation.finishCallback = function(animName:String) {
            if (animName == "BF CORR1") {
                player.characters[0].alpha = 0;
                player.characters[0].visible = false;
                player.characters[1].visible = true;
                player.characters[0].animation.finishCallback = null;
            }
        };
        player.characters[0].playAnim("BF CORR1", true, true);
    } 
    else if (number == 2) {
        player.characters[1].animation.finishCallback = function(animName:String) {
            if (animName == "BF CORR2") {
                player.characters[1].alpha = 0;
                player.characters[1].visible = false;
                player.characters[2].visible = true;
                player.characters[1].animation.finishCallback = null;
            }
        };
        player.characters[1].playAnim("BF CORR2", true, true);
    }

    else if (number == 3) {
        player.characters[2].animation.finishCallback = function(animName:String) {
            if (animName == "BF CORR3") {
                player.characters[2].alpha = 0;
                player.characters[2].visible = false;
                player.characters[3].visible = true;
                iconP1.setIcon("bf-frostbite2");
                boyfriend.iconColor = 0xFFE62145;
                player.characters[2].animation.finishCallback = null;
            }
        };
        player.characters[2].playAnim("BF CORR3", true, true);
    }
    
    else if (number == 4) {
        player.characters[3].animation.finishCallback = function(animName:String) {
            if (animName == "BF CORR4") {
                player.characters[3].playAnim("Corrupt End", true, true);
            }
        };
        player.characters[3].playAnim("BF CORR4", true, true);
    }
}

function headFade(fast:Bool)
{
    var head = opponent.characters[1];
    if (fast == true) {
        if (head.alpha == 0) {tweenTo(head, {alpha: 1}, 0.3);}
        else {tweenTo(head, {alpha: 0}, 0.3);}
    }
    else {
        if (head.alpha == 0) {tweenTo(head, {alpha: 1}, 0.5);}
        else {tweenTo(head, {alpha: 0}, 0.5);}
    }
}

function offsetBF()
{
    // per character offsets
    player.characters[1].x -= 20;
    player.characters[1].y -= 10;
    player.characters[2].x -= 40;
    player.characters[2].y -= 10;
    player.characters[3].x -= 55;
    player.characters[3].y -= 20;

    // push all
    for (char in player.characters) 
    {
        if (char != null) 
        {
            char.x += 50;
            char.y += 150;
            char.cameraOffset.y += 150;
            char.cameraOffset.x -= 100;
        }
    }
    player.characters[3].cameraOffset.y -= 150;
    player.characters[2].cameraOffset.y -= 150;
}

function offsetMonster()
{
    opponent.characters[0].x -= 100;
    opponent.characters[0].y += 100;
    opponent.characters[1].x += 730;
    opponent.characters[1].y += 50;
    opponent.characters[0].cameraOffset.x += 100;
    opponent.characters[0].cameraOffset.y += 50;
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration);
    }
    return null;
}