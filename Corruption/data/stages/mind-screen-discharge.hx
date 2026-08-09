var normalBgParts:Array<FlxSprite> = [];
var fireBgParts:Array<FlxSprite> = [];
var soulPortals:Array<FlxSprite> = [];
var bfPortals:Array<FlxSprite> = [];
var particles:Array<FlxSprite> = [];
var startParticles:Array<FlxSprite> = [];
var breaks:Array<FlxSprite> = [];
var screen:Array<FlxSprite> = [];

// -- INIT VARS -- //
var breaksCounter:Int = 0;
var charBreaksCounter:Int = 0;


function create()
{
    // -- Normal Background layers
    normalBgParts.push(bg); // 0
    normalBgParts.push(bg2); // 1
    normalBgParts.push(mountains); // 2
    normalBgParts.push(rock1); // 3
    normalBgParts.push(rock2); // 4
    normalBgParts.push(platform); // 5
    normalBgParts.push(bfGuitar); // 6

    screen.push(bgEnd); // 0

    // -- Fire Background layers
    fireBgParts.push(bgfire); // 0
    fireBgParts.push(rock1fire); // 1
    fireBgParts.push(rock2fire); // 2
    fireBgParts.push(platformfire); // 3

    // -- Soul Portals
    soulPortals.push(soulPortal); // 0
    soulPortals.push(soulPortalShockwave); // 1

    // -- BF Portals
    bfPortals.push(bfPortal); // 0
    bfPortals.push(bfPortal2); // 1

    // -- Start Particles
    startParticles.push(soulPortalOpen); // 0
    startParticles.push(explosion); // 1
    startParticles.push(smog); // 2
    startParticles.push(fire); // 3
    startParticles.push(glassbreak); // 4


    // -- Breaks
    breaks.push(break1); // 0
    breaks.push(break2); // 1
    breaks.push(break3); // 2
    breaks.push(bfbreak1); // 3
    breaks.push(bfBreak2); // 4
    breaks.push(soulBreak1); // 5
    breaks.push(soulBreak2); // 6

    for (spr in particles) {
        spr.alpha = 0;
    }

    for (spr in startParticles) {
        spr.alpha = 0;
        spr.x -= 100;
        spr.y += 100;
    }

    for (spr in soulPortals) {
        spr.alpha = 0;
        spr.x -= 100;
        spr.y += 100;
    }

    for (spr in bfPortals) {
        spr.alpha = 0;
    }

    // Only for sprites 0 1 2 5 and 6
    for (spr in breaks) {
        if (spr != breaks[3] && spr != breaks[4] && spr != breaks[0] && spr != breaks[1] && spr != breaks[2]) {
            spr.x -= 100;
            spr.y += 100;
        }
        if (spr == breaks[0] || spr == breaks[1] || spr == breaks[2]) {
            spr.x -= 150;
            spr.y += 30;
        }

        spr.alpha = 0;
    }


    screen[0].alpha = 0;
    normalBgParts[1].alpha = 0;
    normalBgParts[6].alpha = 0;
    startParticles[2].y -= 100;
}

function postCreate()
{
    tweenTo(startParticles[2], {alpha: 0.3}, 1.0);
}

function stepHit(curStep:Int)
{
    switch(curStep)
    {
        case 952:
            breakStep();
            
        case 976:
            breakStep();

        case 992:
            breakStep();

        case 1024:
            breakStep();

        case 1044:
            tweenTo(startParticles[0], {alpha: 0}, 1.0);
            startParticles[1].alpha = 0;

        case 1536:
            normalBgParts[6].alpha = 1;

        case 2048:
            normalBgParts[6].alpha = 0;

        case 2176:
            normalBgParts[6].alpha = 1;

        case 2560:
            for (spr in fireBgParts) {
                spr.alpha = 1;
            }
            tweenTo(normalBgParts[0], {alpha: 0}, 5);
            tweenTo(normalBgParts[3], {alpha: 0}, 5);
            tweenTo(normalBgParts[4], {alpha: 0}, 5);
            tweenTo(normalBgParts[5], {alpha: 0}, 5);
            tweenTo(startParticles[3], {alpha: 1}, 5);
            tweenTo(startParticles[2], {alpha: 0}, 5);

        case 2688:
            for (spr in bfPortals) {
                tweenTo(spr, {alpha: 1}, 0.5);
            }

        case 2944:
            for (spr in soulPortals) {
                tweenTo(spr, {alpha: 1}, 0.5);
            }

        case 3488:
            for (spr in bfPortals) {
                tweenTo(spr, {alpha: 0}, 0.5);
            }

            for (spr in soulPortals) {
                tweenTo(spr, {alpha: 0}, 0.5);
            }

        case 3536:
            for (spr in fireBgParts) {
                spr.alpha = 0;
            }
            for (spr in normalBgParts) {
                spr.alpha = 1;
            }
            normalBgParts[0].alpha = 0;
            normalBgParts[1].alpha = 1;
            startParticles[2].alpha = 0.3;
            startParticles[3].alpha = 0;

        case 3822:
            charBreakStep();

        case 4014:
            charBreakStep();

        case 4078:
            charBreakStep();

        case 4178:
            charBreakStep();

        case 4222:
            startParticles[4].alpha = 1;
            startParticles[2].alpha = 0;
            startParticles[4].playAnim('breaky', true, false);

        case 4282:
            for (spr in normalBgParts) {
                spr.alpha = 0;
            }
            tweenTo(startParticles[4], {alpha: 0}, 3);
            screen[0].alpha = 1;
    }

}

function breakStep()
{
    if (breaksCounter == 0) {
        FlxG.camera.shake(0.02, 0.05);
        breaks[0].alpha = 1;
    } 
    else if (breaksCounter == 1) {
        FlxG.camera.shake(0.04, 0.05);
        breaks[1].alpha = 1;
        breaks[0].alpha = 0;
    }
    else if (breaksCounter == 2) {
        FlxG.camera.shake(0.06, 0.05);
        breaks[1].alpha = 0;
        breaks[2].alpha = 1;
    }
    else if (breaksCounter == 3) {
        FlxG.camera.flash(0xFFFFFFFF, 1.0);
        breaks[2].alpha = 0;
        startParticles[0].alpha = 1;
    }

    breaksCounter += 1;
}

function charBreakStep()
{
    if (charBreaksCounter == 0) {
        FlxG.camera.shake(0.02, 0.05);
        breaks[3].alpha = 1;
    }
    else if (charBreaksCounter == 1) {
        FlxG.camera.shake(0.02, 0.05);
        breaks[5].alpha = 1;
    }
    else if (charBreaksCounter == 2) {
        FlxG.camera.shake(0.02, 0.05);
        breaks[3].alpha = 0;
        breaks[5].alpha = 0;
        breaks[4].alpha = 1;
        breaks[6].alpha = 1;
    }
    else if (charBreaksCounter == 3) {
        tweenTo(breaks[4], {alpha: 0}, 1.5);
        tweenTo(breaks[6], {alpha: 0}, 1.5);
    }
    charBreaksCounter += 1;
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);  
    }
    return null;
}

