import funkin.game.PlayState;

var player = strumLines.members[1].characters;
var opponent = strumLines.members[0].characters;

function create()
{
    offsetBF();
    offsetOpponent();
}



function offsetBF()
{
    player[0].cameraOffset.x -= 200;
    player[0].cameraOffset.y -= 50;
}

function offsetOpponent()
{
    opponent[0].x += 50;
    opponent[0].y += 40;
    opponent[0].cameraOffset.y += 70;
}