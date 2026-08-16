var vin1:FlxSprite;
var vigLayers:Array<FlxSprite> = [];
var breatheTween:FlxTween;
var isBreathing:Bool = false;
var tweenAlpha:Float = 0.3;
var otherLayerAlpha:Float = 0.7;

if (Options.vigtoggle == false) {
function create() {
    vin1 = new FlxSprite();
    vin1.loadGraphic(Paths.image("stages/screen/vin1"));
    vin1.setGraphicSize(FlxG.width, FlxG.height);
    vin1.updateHitbox();
    vin1.scrollFactor.set(0, 0);
    vin1.screenCenter();
    vin1.cameras = [camHUD];
    vin1.alpha = 0; 
    vin1.ID = 1;
    insert(0, vin1);

    for (i in 2...6) {
        var vig:FlxSprite = new FlxSprite();
        vig.loadGraphic(Paths.image("stages/screen/vin" + i));
        vig.setGraphicSize(FlxG.width, FlxG.height);
        vig.updateHitbox();
        vig.scrollFactor.set(0, 0);
        vig.screenCenter();
        vig.cameras = [camHUD];
        vig.alpha = 0;
        vig.ID = i;

        vigLayers.push(vig);
        insert(0, vig);
    }
}

function postCreate() {
    reorderVignetteLayers();
}

function beatHit(curBeat:Int) {
    switch(curBeat) {
        case 8:
            showVignette([1], 1);

        case 196:
            cleanupVignettes();

        case 200:
            showVignette([4, 1, 3, 2], 1);

        case 296:
            cleanupVignettes();

        case 312:
            showVignette([1], 1);
        
        case 325:
            cleanupVignettes();
            otherLayerAlpha = 1;
        
        case 328:
            showVignette([4, 1, 3, 2], 1);
        
        case 390:
            cleanupVignettes();

        case 392:
            showVignette([4, 1, 3, 2, 5], 1);

        case 520:
            cleanupVignettes();
    }
}

function update(elapsed:Float) {
    if (isBreathing) {
        if (breatheTween == null) {
            breatheTween = FlxTween.tween(vin1, {alpha: tweenAlpha}, 2.0, {
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

function showVignette(numbers:Array<Int>, duration:Float = 1.0) {
    isBreathing = false;

    if (breatheTween != null) {
        breatheTween.cancel();
        breatheTween = null;
    }

    var newOrder:Array<FlxSprite> = [];

    for (num in numbers) {
        if (num == 1) continue;
        var layer = getLayerByVin(num);
        if (layer != null) {
            newOrder.push(layer);
        }
    }

    for (layer in vigLayers) {
        if (!newOrder.contains(layer)) {
            newOrder.push(layer);
        }
    }

    vigLayers = newOrder;
    reorderVignetteLayers();

    var shouldShowVin1:Bool = numbers.contains(1);

    if (shouldShowVin1) {
        tweenTo(vin1, {alpha: 1}, duration, {
            onComplete: function(twn:FlxTween) {
                isBreathing = true;
            }
        });
    } else if (vin1.alpha > 0) {
        tweenTo(vin1, {alpha: 0}, duration);
    }

    for (layer in vigLayers) {
        if (numbers.contains(layer.ID)) {
            tweenTo(layer, {alpha: otherLayerAlpha}, duration);
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

    if (vin1 != null) {
        FlxTween.globalManager.cancelTweensOf(vin1);
        if (vin1.alpha > 0) {
            FlxTween.tween(vin1, {alpha: 0}, duration);
        }
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

function reorderVignetteLayers() {
    var baseIndex:Int = 0;
    if (cpuStrums != null && members.contains(cpuStrums)) {
        baseIndex = members.indexOf(cpuStrums);
    }

    if (members.contains(vin1)) remove(vin1);
    for (vig in vigLayers) {
        if (members.contains(vig)) remove(vig);
    }

    for (i in 0...vigLayers.length) {
        insert(baseIndex + i, vigLayers[i]);
    }

    insert(baseIndex + vigLayers.length, vin1);
}

function getLayerByVin(vinNum:Int):FlxSprite {
    if (vinNum == 1) return vin1;

    for (layer in vigLayers) {
        if (layer.ID == vinNum) {
            return layer;
        }
    }
    return null;
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);  
    }
    return null;
}
}