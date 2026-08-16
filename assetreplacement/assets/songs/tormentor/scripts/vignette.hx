import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var vigLayers:Array<FlxSprite> = [];
var breatheTween:FlxTween;
var isBreathing:Bool = false;

var tweenAlpha:Float = 0.3;

if (Options.vigtoggle == false) {
function create() {
    for (i in 1...2) {
        var vig:FlxSprite = new FlxSprite();
        vig.loadGraphic(Paths.image("stages/screen/vin" + i));
        vig.setGraphicSize(FlxG.width, FlxG.height);
        vig.updateHitbox();
        vig.scrollFactor.set(0, 0);
        vig.screenCenter();
        vig.cameras = [camHUD];
        vig.alpha = 0;

        vigLayers.push(vig);
        insert(0, vig);
    }
}

function postCreate() {
    for (vig in vigLayers) {
        if (cpuStrums != null && members.contains(cpuStrums)) {
            remove(vig);
            insert(members.indexOf(cpuStrums), vig);
        }
    }
}

function beatHit(curBeat:Int) {
    switch(curBeat) {
        case 16:
            showVignette([1], 1);

        case 192:
            tweenAlpha = 0.9;
            if (isBreathing && breatheTween != null) {
                breatheTween.cancel();
                breatheTween = null;
            }

        case 224:
            tweenAlpha = 0.8;
            if (isBreathing && breatheTween != null) {
                breatheTween.cancel();
                breatheTween = null;
            }

        case 288:
            cleanupVignettes();
    }
}

function update(elapsed:Float) {
    if (isBreathing) {
        if (breatheTween == null) {
            breatheTween = FlxTween.tween(vigLayers[0], {alpha: tweenAlpha}, 2.0, {
                ease: FlxEase.sineInOut,
                type: 4,
                onUpdate: function(twn:FlxTween) {
                    if (twn.scale >= 0.5) {
                        // halfway point or target update logic
                    }
                }
            });
        }
    } else {
        if (breatheTween != null) {
            breatheTween.cancel();
            breatheTween = null;
        }
    }
}

function showVignette(numbers:Array<Int>, duration:Float = 1.0) {
    isBreathing = false;

    for (i in 0...vigLayers.length) {
        var layerNum = i + 1;
        var layer = vigLayers[i];

        if (numbers.contains(layerNum)) {
            tweenTo(layer, {alpha: 1}, duration, {
                onComplete: function(twn:FlxTween) {
                    isBreathing = true;
                }
            });
        } else if (layer.alpha > 0) {
            tweenTo(layer, {alpha: 0}, duration);
        }
    }
}

function cleanupVignettes(duration:Float = 0.2) {
    isBreathing = false;

    if (breatheTween != null) {
        breatheTween.cancel();
        breatheTween = null;
    }

    for (layer in vigLayers) {
        if (layer != null) {
            FlxTween.globalManager.cancelTweensOf(layer);
            
            if (layer.alpha > 0) {
                FlxTween.tween(layer, {alpha: 0}, duration);
            }
        }
    }
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);  
    }
    return null;
}
}