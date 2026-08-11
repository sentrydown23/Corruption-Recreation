var player = strumLines.members[1].characters;
var opponent = strumLines.members[0].characters;

function postCreate()
{
    offsetBF();
    offsetOpponent();

    opponent[1].visible = false;
}

function beatHit(_)
{
    switch(_)
    {
        case 96:
            opponent[0].visible = false;
            opponent[1].visible = true;
            iconP2.setIcon("dad-lament-2");
    }
}

function offsetBF()
{
    player[0].y += 100;
    player[0].cameraOffset.y -= 50;
}

function offsetOpponent()
{
    opponent[1].x -= 16;
    opponent[1].cameraOffset.x -= 10;
}