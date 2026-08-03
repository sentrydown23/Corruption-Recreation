import funkin.game.PlayState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var player = strumLines.members[1].characters;
var opponent = strumLines.members[0].characters;

// Arrays to safely store the starting coordinates of each player character
var playerHomeX:Array<Float> = [];
var playerHomeY:Array<Float> = [];

function postCreate()
{
    offsetBF();
    offsetOpponent();

    opponent[1].visible = false;
    opponent[2].visible = false;
    opponent[3].visible = false;

    player[1].visible = false;
    player[2].visible = false;
    player[3].visible = false;

    // Save every player's exact X and Y position AFTER offsets are applied
    for (i in 0...player.length) {
        if (player[i] != null) {
            playerHomeX[i] = player[i].x;
            playerHomeY[i] = player[i].y;
        }
    }
}

function beatHit(_)
{
    switch(_)
    {
        case 190:
            playerHotswap(2, 0.5, 0);

        case 254:
            playerHotswap(1, 0.5, 2);

        case 350:
            playerHotswap(3, 0.5, 1);

        case 352:
            opponent[0].visible = false;
            opponent[3].visible = true;
            iconP2.setIcon("dad-lament-1");

        case 416:
            opponent[3].visible = false;
            opponent[1].visible = true;
            iconP2.setIcon("dad-dm-2");
            playerHotswap(0, 0.5, 3);

        case 544:
            opponent[1].visible = false;
            opponent[2].visible = true;
            iconP2.setIcon("dad-dm-3");
    }
}

function offsetBF()
{
    player[0].y += 100;
    player[0].cameraOffset.y -= 50;
    player[2].x -= 10;
    player[2].y += 20;
    player[2].cameraOffset.x -= 50;
    player[3].y += 80;
    player[3].cameraOffset.x -= 50;
    player[1].cameraOffset.x -= 50;
}

function offsetOpponent()
{
    opponent[1].x -= 12;
    opponent[1].cameraOffset.x -= 10;
    opponent[2].x -= 27;
    opponent[2].cameraOffset.x -= 10;
    opponent[3].x -= 16 + 32;
    opponent[3].cameraOffset.x -= 10;
}

function playerHotswap(incomingIndex:Int, duration:Float = 0.4, outgoingIndex:Int)
{
    if (player[incomingIndex] == null || player[outgoingIndex] == null) return;

    var incomingChar = player[incomingIndex];
    var activeChar = player[outgoingIndex];
    var spawnRightOffset:Float = 600;
    var slideRightDistance:Float = 500;

    incomingChar.x = playerHomeX[incomingIndex] + spawnRightOffset;
    incomingChar.alpha = 0.0;
    incomingChar.visible = true;

    switch(incomingIndex)
    {
        case 0:
            iconP1.setIcon("bf-corrupted");
        case 1:
            iconP1.setIcon("spookyfull");
        case 3:
            iconP1.setIcon("momfull");
        case 2:
            iconP1.setIcon("picofull");
    }

    FlxTween.tween(incomingChar, { x: playerHomeX[incomingIndex] }, duration, {
        ease: FlxEase.expoOut
    });

    FlxTween.tween(incomingChar, { alpha: 1.0 }, duration, {
        ease: FlxEase.expoOut
    });

    FlxTween.tween(activeChar, { x: playerHomeX[outgoingIndex] + slideRightDistance }, duration, {
        ease: FlxEase.expoIn,
        onComplete: function(twn:FlxTween) {
            activeChar.visible = false; 
        }
    });

    FlxTween.tween(activeChar, { alpha: 0.0 }, duration, {
        ease: FlxEase.expoIn
    });
}
