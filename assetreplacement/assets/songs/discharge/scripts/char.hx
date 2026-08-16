var player = strumLines.members[1].characters;
var opponent = strumLines.members[0].characters;

var opponentLoopActive:Bool = false;

var oppDecreaseDuration:Float = 1.0;
var oppWaitDuration:Float = 1.0;
var oppReverseDuration:Float = 1.5;
var oppCancelFadeDuration:Float = 1.5;
var oppReverseTargetAlpha:Float = 0.005;

var oppTween:FlxTween;
var oppTimer:FlxTimer;

function create()
{
    offsetBF();
    offsetOpponent();

    opponent[0].visible = false;
    opponent[1].visible = false;
    opponent[2].visible = false;
    opponent[3].visible = false;
    player[0].visible = false;
    player[1].visible = false;
    player[3].visible = false;
}


function beatHit(_)
{
    switch(_)
    {
        case 256:
            opponent[1].visible = true;
            opponent[1].playAnim('shredit', true, false);

        case 286:
            player[2].visible = false;
            player[3].visible = true;
            player[3].playAnim('guitarBONK', true, false);

        case 288:
            opponent[1].visible = false;
            opponent[2].visible = true;

        case 352:
            opponent[2].visible = false;
            opponent[0].visible = true;

        case 384:
            player[3].visible = false;
            player[0].visible = true;

        case 480:
            opponent[0].visible = false;
            opponent[2].visible = true;

        case 511:
            opponent[2].visible = false;
            opponent[0].visible = true;

        case 512:
            opponent[2].visible = true;
            opponent[0].visible = false;
            player[3].visible = true;
            player[0].visible = false;

        case 544:
            player[3].visible = false;
            player[0].visible = true;

        case 552:
            opponent[2].visible = false;
            opponent[0].visible = true;

        case 648:
            player[0].visible = false;
            player[1].visible = true;

        case 736:
            player[1].visible = false;
            player[2].visible = true;
            opponent[0].visible = false;
            opponent[2].visible = true;

        case 832:
            opponent[2].visible = false;
            opponent[0].visible = true;

        case 862:
            player[2].visible = false;
            player[0].visible = true;

        case 972:
            opponent[0].visible = false;
            opponent[2].visible = true;
        
        case 996:
            opponent[0].visible = true;
            opponent[2].visible = false;

        case 988:
            player[0].visible = false;
            player[3].visible = true;
    }
}

function stepHit(curStep:Int) 
{
    switch(curStep) 
    {
        case 1025:
            player[2].playAnim('yoisthatsbf', true, false);

        case 4062:
            player[3].visible = false;
            player[0].visible = true;

        case 4316:
            player[0].visible = false;
            player[3].visible = true;
            player[3].playAnim('guitarBREAK', true, false);
            opponent[0].visible = false;
            opponent[3].visible = true;
            opponent[3].playAnim('yeetboi', true, false);
    }
}

function offsetBF()
{
    player[0].cameraOffset.x -= 200;
    player[0].cameraOffset.y -= 50;

    player[1].x -= 20;
    player[1].cameraOffset.x -= 180;
    player[1].cameraOffset.y -= 50;

    // player[2].x -= 20; we dont do this no moe
    player[2].cameraOffset.x -= 200;
    player[2].cameraOffset.y -= 50;

    player[3].x -= 180;
    player[3].cameraOffset.x -= 200;
    player[3].cameraOffset.y -= 50;
}

function offsetOpponent()
{
    opponent[0].x += 50;
    opponent[0].y += 40;
    opponent[0].cameraOffset.y += 70;

    opponent[1].x -= 50;
    opponent[1].y -= 50;

    opponent[2].x += 100;
    opponent[2].y += 40;

    opponent[3].y += 100;
    opponent[3].x += 100;
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);  
    }
    return null;
}