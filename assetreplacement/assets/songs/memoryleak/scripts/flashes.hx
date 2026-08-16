import openfl.display.Shape;
import openfl.display.GradientType;
import openfl.display.SpreadMethod;
import openfl.display.InterpolationMethod;
import openfl.geom.Matrix;
import openfl.display.BlendMode;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var colorList:Array<Int> = [
    0xFFFFFF,
    0xD4D4D4,
    0x888888,
    0x444444,
    0x1A1A1A
];

var colorIndex:Int = 0;
var fastFlashStep:Int = 0;

function postCreate() {}

function createGradientOverlay(colorRGB:Int):FlxSprite {
    var overlay:FlxSprite = new FlxSprite(0, 0);
    overlay.makeGraphic(FlxG.width, FlxG.height, 0x00000000);
    overlay.scrollFactor.set(0, 0);
    overlay.blend = BlendMode.ADD;
    overlay.cameras = [camHUD];

    var shape:Shape = new Shape();
    var width:Float = FlxG.width;
    var height:Float = FlxG.height;

    var linMatrix:Matrix = new Matrix();
    linMatrix.createGradientBox(width, height, Math.PI / 2, 0, 0);
    
    shape.graphics.beginGradientFill(
        GradientType.LINEAR,
        [colorRGB, colorRGB, colorRGB, colorRGB],
        [0.0, 0.0, 0.35, 0.85],
        [0, 130, 195, 255],
        linMatrix,
        SpreadMethod.PAD,
        InterpolationMethod.RGB,
        0.0
    );
    shape.graphics.drawRect(0, 0, width, height);
    shape.graphics.endFill();

    var radMatrix:Matrix = new Matrix();
    radMatrix.createGradientBox(width * 1.3, height * 1.3, 0, -width * 0.15, -height * 0.15);
    
    shape.graphics.beginGradientFill(
        GradientType.RADIAL,
        [colorRGB, colorRGB, colorRGB],
        [0.0, 0.15, 0.65],
        [0, 170, 255],
        radMatrix,
        SpreadMethod.PAD,
        InterpolationMethod.RGB,
        0.0
    );
    shape.graphics.drawRect(0, 0, width, height);
    shape.graphics.endFill();

    overlay.pixels.draw(shape);
    return overlay;
}

function spawnOutlinePulse(char:Dynamic, colorRGB:Int, duration:Float, maxAlpha:Float = 0.5) {
    if (char == null || char.graphic == null) return;

    var pulse:FlxSprite = new FlxSprite(char.x, char.y);
    pulse.frames = char.frames;
    
    if (char.animation.curAnim != null) {
        pulse.animation.copyFrom(char.animation);
        pulse.animation.play(char.animation.curAnim.name, true, false, char.animation.curAnim.curFrame);
    }

    pulse.flipX = char.flipX;
    pulse.flipY = char.flipY;
    pulse.scale.set(char.scale.x, char.scale.y);
    pulse.updateHitbox();

    var syncOffsets = function() {
        if (char == null || pulse == null) return;
        
        var curAnimName:String = char.animation.curAnim != null ? char.animation.curAnim.name : "";
        
        if (Reflect.hasField(char, "animOffsets") && char.animOffsets != null && char.animOffsets.exists(curAnimName)) {
            var offsets:Array<Float> = char.animOffsets.get(curAnimName);
            pulse.offset.set(offsets[0], offsets[1]);
        } 
        else {
            pulse.offset.set(char.offset.x, char.offset.y);
        }
    };

    syncOffsets();

    pulse.scrollFactor.set(char.scrollFactor.x, char.scrollFactor.y);
    pulse.cameras = char.cameras;

    pulse.color = FlxColor.fromInt(colorRGB);
    pulse.blend = BlendMode.ADD;
    pulse.alpha = maxAlpha;

    insert(members.indexOf(char), pulse);

    var startScaleX:Float = char.scale.x;
    var startScaleY:Float = char.scale.y;
    var targetScaleX:Float = startScaleX * 1.20;
    var targetScaleY:Float = startScaleY * 1.20;

    FlxTween.tween(pulse.scale, {x: targetScaleX, y: targetScaleY}, duration, {ease: FlxEase.quadOut});
    
    FlxTween.tween(pulse, {alpha: 0.0}, duration, {
        ease: FlxEase.quadOut,
        onUpdate: function(t:FlxTween) {
            if (char != null && pulse != null && pulse.exists) {
                pulse.x = char.x;
                pulse.y = char.y;
                
                if (char.animation.curAnim != null && pulse.animation.curAnim != null) {
                    if (pulse.animation.curAnim.name != char.animation.curAnim.name) {
                        pulse.animation.play(char.animation.curAnim.name, true, false, char.animation.curAnim.curFrame);
                    } else {
                        pulse.animation.curAnim.curFrame = char.animation.curAnim.curFrame;
                    }
                }

                syncOffsets();
            }
        },
        onComplete: function(t:FlxTween) {
            pulse.destroy();
        }
    });
}

function flashPulse(duration:Float = 0.45, maxAlpha:Float = 0.5) {
    var currentColor:Int = colorList[colorIndex];
    colorIndex = (colorIndex + 1) % colorList.length;

    var overlay:FlxSprite = createGradientOverlay(currentColor);
    overlay.alpha = maxAlpha;
    add(overlay);

    FlxTween.tween(overlay, {alpha: 0.0}, duration, {
        ease: FlxEase.quadOut,
        onComplete: function(t:FlxTween) {
            overlay.destroy();
        }
    });

    if (dad != null) spawnOutlinePulse(dad, currentColor, duration, maxAlpha);
    if (boyfriend != null) spawnOutlinePulse(boyfriend, currentColor, duration, maxAlpha);
}

function stepHit(curStep:Int) {
    var curBeat:Int = Math.floor(curStep / 4);

    if (curBeat >= 148 && curBeat <= 195) {
        var stepInMeasure:Int = curStep % 16;

        if (stepInMeasure == 0) {
            flashPulse(0.35, 0.2);
            fastFlashStep = 0;
        } 
        else if (stepInMeasure >= 2 && stepInMeasure <= 8 && (stepInMeasure % 2 == 0)) {
            var rampedAlpha:Float = 0.03 + (fastFlashStep * 0.03);
            flashPulse(0.15, rampedAlpha);
            fastFlashStep++;
        }
    }
}