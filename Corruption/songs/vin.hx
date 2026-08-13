var hurtVinPath:String = "hurtvin";
var lowHealthPath:String = "lowhealth";

var missSound1:String = "noteMiss1";
var missSound2:String = "noteMiss2";
var missSound3:String = "noteMiss3";

var camVIN:FlxCamera;
var hurtSprite:FlxSprite;
var lowHealthSprite:FlxSprite;

var missTimer:FlxTimer;
var hurtTween:FlxTween;
var lowHealthTween:FlxTween;
var isLowHealthShowing:Bool = false;

var canTickHurt:Bool = true;
var tickCooldown:Float = 0.2;

function postCreate() {
    camVIN = new FlxCamera();
    camVIN.bgColor = 0x00000000;
    FlxG.cameras.add(camVIN, false);


    // pixel stuff
    switch(SONG.meta.name) {
        case "senpai-remix", "dead-pixel", "treacherous-thorns", "roots":
            hurtVinPath = "hurtvinPixel";
            lowHealthPath = "lowhealthPixel";

            missSound1 = "noteMissPixel1";
            missSound2 = "noteMissPixel2";
            missSound3 = "noteMissPixel3";
    }

    hurtSprite = new FlxSprite(0, 0).loadGraphic(Paths.image(hurtVinPath));
    hurtSprite.setGraphicSize(FlxG.width, FlxG.height);
    hurtSprite.updateHitbox();
    hurtSprite.screenCenter();
    hurtSprite.scrollFactor.set(0, 0);
    hurtSprite.cameras = [camVIN];
    hurtSprite.alpha = 0;
    add(hurtSprite);

    lowHealthSprite = new FlxSprite(0, 0).loadGraphic(Paths.image(lowHealthPath));
    lowHealthSprite.setGraphicSize(FlxG.width, FlxG.height);
    lowHealthSprite.updateHitbox();
    lowHealthSprite.screenCenter();
    lowHealthSprite.scrollFactor.set(0, 0);
    lowHealthSprite.cameras = [camVIN];
    lowHealthSprite.alpha = 0;
    add(lowHealthSprite);
}

function onPlayerMiss(event) {
    var noteType:String = event.noteType;
    if (noteType != "pico-note" && noteType != "guitar") {
        if (!canTickHurt) {
            return;
        }

        canTickHurt = false;
        new FlxTimer().start(tickCooldown, function(tmr:FlxTimer) {
            canTickHurt = true;
        });

        if (hurtTween != null) {
            hurtTween.cancel();
        }
        if (missTimer != null) {
            missTimer.cancel();
        }

        hurtSprite.alpha = Math.min(1.0, hurtSprite.alpha + 0.1);

        missTimer = new FlxTimer().start(3.0, function(tmr:FlxTimer) {
            hurtTween = FlxTween.tween(hurtSprite, {alpha: 0}, 0.5);
        });

        var soundList:Array<String> = [missSound1, missSound2, missSound3];
        var chosenSound:String = soundList[FlxG.random.int(0, soundList.length - 1)];
        FlxG.sound.play(Paths.sound(chosenSound), 1);
    }
}

function update(elapsed:Float) {
    if (health <= 0.5 && !isLowHealthShowing) {
        isLowHealthShowing = true;
        if (lowHealthTween != null) {
            lowHealthTween.cancel();
        }
        lowHealthTween = FlxTween.tween(lowHealthSprite, {alpha: 1}, 1.0);
    } else if (health >= 0.6 && isLowHealthShowing) {
        isLowHealthShowing = false;
        if (lowHealthTween != null) {
            lowHealthTween.cancel();
        }
        lowHealthTween = FlxTween.tween(lowHealthSprite, {alpha: 0}, 1.0);
    }
}