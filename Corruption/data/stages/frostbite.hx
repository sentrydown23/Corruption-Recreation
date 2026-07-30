var UpperBoppers:Array<FlxSprite> = [];
var BottomBoppers:Array<FlxSprite> = [];
var bgParts:Array<FlxSprite> = [];

function create()
{
}

function postCreate()
{
    // Upper Boppers
    UpperBoppers.push(FrostBoppers);
    UpperBoppers.push(FrostPicoBoppers);
    
    // Bottom Boppers
    BottomBoppers.push(FrostBottomBoppers1);
    BottomBoppers.push(FrostBottomBoppers2);
    BottomBoppers.push(FrostBottomBoppers3);
    BottomBoppers.push(FrostBottomBoppersFinal);

    // Rest of Stage
    bgParts.push(FrostBG);
    bgParts.push(FrostStairs);
    bgParts.push(FrostSnow);
    bgParts.push(FrostTree);

    for (spr in UpperBoppers) {
        spr.alpha = 0;
        spr.y -= -10;
    }

    for (spr in BottomBoppers) {
        spr.alpha = 0;
    }

    UpperBoppers[0].alpha = 1;
    BottomBoppers[0].alpha = 1;
}

function beatHit(curBeat:Int)
{

    switch(curBeat)
    {

        case 80:
            BottomBoppers[0].alpha = 0;
            BottomBoppers[1].alpha = 1;

        case 178:
            BottomBoppers[1].alpha = 0;
            BottomBoppers[2].alpha = 1;

        case 210:
            for (spr in bgParts) {
                spr.alpha = 0;
            }
            for (spr in UpperBoppers) {
                spr.alpha = 0;
            }
            for (spr in BottomBoppers) {
                spr.alpha = 0;
            }

        case 274:
            for (spr in bgParts) {
                spr.alpha = 1;
            }
            BottomBoppers[2].alpha = 1;
            UpperBoppers[1].alpha = 1;

        case 342:
            BottomBoppers[3].alpha = 1;
    }

    // Checks for every downbeat (0, 2, 4, 6...) just like the standard characters
    if (curBeat % 2 == 0) {
        
        // Loop through all upper boppers and force them to bop
        for (spr in UpperBoppers) {
            if (spr.alpha > 0) { // Only play if they are visible
                spr.playAnim(spr.animation.curAnim.name, true);
            }
        }

        // Loop through all bottom boppers and force them to bop
        for (spr in BottomBoppers) {
            if (spr.alpha > 0) { // Only play if they are visible
                spr.playAnim(spr.animation.curAnim.name, true);
            }
        }
    }
}
