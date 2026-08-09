var player = strumLines.members[1].characters;
var opponent = strumLines.members[0].characters;
var playerDefaultAngle:Float = 0;

function create()
{
    offsetBF();
    offsetOpponent();

    opponent[1].visible = false;
    opponent[2].visible = false;
    player[1].visible = false;
    player[2].visible = false;
    player[3].visible = false;
    player[4].visible = false;
    player[5].visible = false;
}


function stepHit(curStep:Int)
{
    switch(curStep)
    {
        case 400:
            player[0].visible = false;
            player[1].visible = true;
            player[1].playAnim("yeet", true);

        case 401:
            for (char in player) {
                FlxTween.tween(char, {y: -3700}, 0.2, {ease: FlxEase.expoIn});
            }

        case 465:
            for (char in opponent) {
                FlxTween.tween(char, {y: -3600}, 7, {ease: FlxEase.quadOut});
            }

        case 772:
            player[2].visible = true;
            player[1].visible = false;
            opponent[1].visible = true;
            opponent[0].visible = false;

        case 1676:
            player[2].visible = false;
            player[3].visible = true;

        case 1680:
            for (char in player) {
                FlxTween.tween(char, {angle: 800}, 43);
            }

        case 1808:
            player[3].visible = false;
            player[4].visible = true;
            opponent[2].y -= 150;


        case 2208:
            opponent[1].visible = false;
            opponent[2].visible =  true;
            opponent[2].playAnim('charge', true, true);
            player[4].visible = false;
            player[3].visible = true;

        case 2224:
            for (char in player) {
                FlxTween.cancelTweensOf(char, ["angle"]);
            }

        case 2248:
            opponent[2].playAnim('attack', true, false);

        case 2270:
            player[3].visible = false;
            player[5].visible = true;
            player[5].playAnim('youch', true, false);
    }
}


function offsetBF()
{
    player[0].cameraOffset.x -= 200;
    player[0].cameraOffset.y -= 50;

    player[1].cameraOffset.x -= 200;
    player[1].cameraOffset.y -= 50;
    player[1].x -= 100;

    player[2].cameraOffset.x -= 200;
    player[2].cameraOffset.y -= 50;
    player[2].x -= 40;
    player[2].y += 5;

    player[3].cameraOffset.x -= 200;
    player[3].cameraOffset.y -= 50;
    player[3].x -= 40;
    player[3].y += 5;

    player[4].cameraOffset.x -= 200;
    player[4].cameraOffset.y -= 50;
    player[4].x -= 55;
    player[4].y += 4;

    player[5].cameraOffset.x -= 200;
    player[5].cameraOffset.y -= 50;
    player[5].x -= 55;
    player[5].y += 4;
}

function offsetOpponent()
{
    opponent[0].x += 50;
    opponent[0].y += 40;
    opponent[0].cameraOffset.y += 70;

    opponent[1].x += 50;
    opponent[1].y += 40;
    opponent[1].cameraOffset.y += 70;

    opponent[2].x += 40;
    opponent[2].y += 30;
    opponent[2].cameraOffset.y += 70;
}