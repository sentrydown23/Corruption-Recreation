import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var camVignette:FlxCamera = new FlxCamera();
var vigLayer1:FlxSprite = new FlxSprite();
var vigLayer2:FlxSprite = new FlxSprite();
var vigLayer3:FlxSprite = new FlxSprite();
var breatheTween:FlxTween;

var breathAlpha:Float = 0.8;

var isBreathing:Bool = false;

function postCreate() {
    camVignette.bgColor = 0x00000000;
    FlxG.cameras.add(camVignette, false);

    createVignette();

    insert(0, vigLayer1);

    vigLayer1.alpha = 0;
}

function beatHit(_)
{
    switch(_)
    {
        case 1:
            vignette(1);

        case 208:
            breathAlpha = 0.4;

        case 400:
            breathAlpha = 0.9;
    }
}

function update(elapsed:Float) {
    if (isBreathing) {
        if (breatheTween == null) {
            breatheTween = FlxTween.tween(camVignette, {alpha: breathAlpha}, 2.0, {
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
    vigLayer1.loadGraphic(Paths.image("stages/philly2/vin1"));
    vigLayer1.setGraphicSize(FlxG.width, FlxG.height);
    vigLayer1.updateHitbox();
    vigLayer1.scrollFactor.set(0, 0);
    vigLayer1.screenCenter();
    vigLayer1.cameras = [camVignette];
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