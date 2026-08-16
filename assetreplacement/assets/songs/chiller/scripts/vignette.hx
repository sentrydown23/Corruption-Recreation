var vigLayers:Array<FlxSprite> = [];
var breatheTween:FlxTween;
var isBreathing:Bool = false;

if (Options.vigtoggle == false) {
function postCreate() {

    // Create 5 layers cleanly using a loop
    for (i in 1...4) {
        var vig:FlxSprite = new FlxSprite();
        vig.loadGraphic(Paths.image("stages/frostbite/vignette/vignette" + i));
        vig.setGraphicSize(FlxG.width, FlxG.height);
        vig.updateHitbox();
        vig.scrollFactor.set(0, 0);
        vig.screenCenter();
        vig.cameras = [camHUD];
        vig.alpha = 0;

        vigLayers.push(vig);
        insert(0, vig);

        showVignette([3]);
    }
}

function beatHit(_)
{
    switch(_)
    {
        case 320:
            cleanupVignettes();
    }
}

function update(elapsed:Float)
{
    if (isBreathing) {
    for (spr in vigLayers) {
        if (breatheTween == null) {
            breatheTween = FlxTween.tween(spr, {alpha: 0.8}, 1.0, {
                ease: FlxEase.sineInOut,
                type: 4 // FlxTween.PINGPONG
            });
        }
    } 
}
    else {
        if (breatheTween != null) {
            breatheTween.cancel();
            breatheTween = null;
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

function showVignette(numbers:Array<Int>, duration:Float = 1.0) {
    isBreathing = false;

    for (i in 0...vigLayers.length) {
        var layerNum = i + 1;
        var layer = vigLayers[i];

        if (numbers.contains(layerNum)) {
            // Fade in selected layers
            tweenTo(layer, {alpha: 1}, duration, {
                onComplete: function(twn:FlxTween) {
                    isBreathing = true;
                }
            });
        } else if (layer.alpha > 0) {
            // Fade out unselected layers
            tweenTo(layer, {alpha: 0}, duration);
        }
    }
}

function cleanupVignettes(duration:Float = 0.2) {
    isBreathing = false;

    // Cancel any active camera breathing tween
    if (breatheTween != null) {
        breatheTween.cancel();
        breatheTween = null;
    }

    // Cancel all active layer tweens and fade out visible layers
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