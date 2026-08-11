var player = strumLines.members[1].characters;
var opponent = strumLines.members[0].characters;

var lastHalfStep:Int = -1; 

function postCreate()
{
    offsetBF();
    offsetOpponent();

    opponent[1].visible = false;
    opponent[2].visible = false;
    opponent[3].visible = false;
    opponent[4].visible = false;
    opponent[5].visible = false;
}

function stepHit(_)
{
    switch(_)
    {
        case 1153:
            for (char in opponent) {
                if (char != null) {
                    char.visible = false;
                }
            }
            for (char in player) {
                if (char != null) {
                    char.visible = false;
                }
            }
    }
}

function offsetBF()
{
    player[0].y += 100;
    player[0].cameraOffset.y -= 50;
}

function offsetOpponent()
{
    offsetVal = 16;

    opponent[1].x -= offsetVal;
    opponent[1].cameraOffset.x -= 10;
    opponent[2].x -= offsetVal + 21;
    opponent[3].x -= offsetVal + 42;
    opponent[4].x -= offsetVal + 63;
    opponent[5].x -= offsetVal + 84;
}

function swapDad(Index:Int)
{
    Index = Index -= 1;
    for (char in opponent) {
        if (char != null) {
            char.visible = false;
        }
    }

    opponent[Index].visible = true;

    switch(Index)
    {
        case 1, 3, 5:
            iconP2.setIcon("dad-dusk-2");
        case 2, 4:
            iconP2.setIcon("dad-dusk-1");
    }
}

function update(elapsed:Float) {
    var currentHalfStep:Int = Math.floor(curStepFloat * 2);

    if (currentHalfStep > lastHalfStep) {
        lastHalfStep = currentHalfStep;
        
        var stepString:String = Std.string(currentHalfStep * 0.5);
        
        switch (stepString) {
            case "256.5":
                swapDad(5);
            case "512.5":
                swapDad(6);
            case "544.5":
                swapDad(2);
            case "558.5":
                swapDad(4);
            case "784.5":
                swapDad(2);
            case "844.5":
                swapDad(6);
            case "896.5":
                swapDad(5);
            case "1024.5":
                swapDad(6);
            case "1040.5":
                swapDad(2);
            case "1056.5":
                swapDad(4);
            case "1120.5":
                swapDad(2);
        }
    }
}