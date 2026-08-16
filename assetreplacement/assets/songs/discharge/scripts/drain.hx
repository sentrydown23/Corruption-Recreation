var isDraining:Bool = false;
var drainRate:Float = 0.1;

function update(elapsed:Float) {
    if (isDraining && health > 0.1) {
        health -= drainRate * elapsed;
        if (health < 0.1) health = 0.1;
    }
}

function beatHit(curBeat:Int)
{
    switch(curBeat)
    {
        case 672:
            isDraining = true;

        case 800:
            drainRate = 0.2;

        case 862:
            isDraining = false;
    }
}