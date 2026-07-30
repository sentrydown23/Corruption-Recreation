import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var camVignette:FlxCamera = new FlxCamera();
var vigLayer1:FlxSprite = new FlxSprite();
var vigLayer2:FlxSprite = new FlxSprite();
var vigLayer3:FlxSprite = new FlxSprite();
var breatheTween:FlxTween;

var isBreathing:Bool = false;

function postCreate() {
    camVignette.bgColor = 0x00000000;
    FlxG.cameras.add(camVignette, false);

    createVignette();

    insert(0, vigLayer1);
    insert(0, vigLayer2);
    insert(0, vigLayer3);

    vigLayer1.alpha = 0;
    vigLayer2.alpha = 0;
    vigLayer3.alpha = 0;
}

function beatHit(_)
{
    switch(_)
    {
        case 16:
            vignette(2);
    }
}

function update(elapsed:Float) {
    if (isBreathing) {
        if (breatheTween == null) {
            breatheTween = FlxTween.tween(camVignette, {alpha: 0.8}, 2.0, {
                ease: FlxEase.sineInOut,
                type: 4
            });
        }
    } else {
        if (breatheTween != null) {
            breatheTween.cancel();
            breatheTween = null;
        }
    }
}

function createVignette()
{
    vigLayer1.loadGraphic(Paths.image("stages/frostbite/vignette/vignette1"));
    vigLayer1.setGraphicSize(FlxG.width, FlxG.height);
    vigLayer1.updateHitbox();
    vigLayer1.scrollFactor.set(0, 0);
    vigLayer1.screenCenter();
    vigLayer1.cameras = [camVignette];

    vigLayer2.loadGraphic(Paths.image("stages/frostbite/vignette/vignette2"));
    vigLayer2.setGraphicSize(FlxG.width, FlxG.height);
    vigLayer2.updateHitbox();
    vigLayer2.scrollFactor.set(0, 0);
    vigLayer2.screenCenter();
    vigLayer2.cameras = [camVignette];

    vigLayer3.loadGraphic(Paths.image("stages/frostbite/vignette/vignette3"));
    vigLayer3.setGraphicSize(FlxG.width, FlxG.height);
    vigLayer3.updateHitbox();
    vigLayer3.scrollFactor.set(0, 0);
    vigLayer3.screenCenter();
    vigLayer3.cameras = [camVignette];
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);
    }
    return null;
}

function vignette(number:Int) {
    if (number != 1 && number != 2 && number != 3) return;

    isBreathing = false;
    camVignette.alpha = 1.0;

    var layers = [vigLayer1, vigLayer2, vigLayer3];
    var target = layers[number - 1];

    for (layer in layers) {
        if (layer == target) {
            tweenTo(layer, {alpha: 1}, 1, {
                onComplete: function(twn:FlxTween) {
                    isBreathing = true;
                }
            });
        } else if (layer.alpha != 0) {
            tweenTo(layer, {alpha: 0}, 1);
        }
    }
}

function cleanupVignettes() {
    isBreathing = false;
    camVignette.alpha = 1.0;

    var layers = [vigLayer1, vigLayer2, vigLayer3];
    for (layer in layers) {
        if (layer.alpha > 0) {
            tweenTo(layer, {alpha: 0}, 0.2);
        }
    }
}