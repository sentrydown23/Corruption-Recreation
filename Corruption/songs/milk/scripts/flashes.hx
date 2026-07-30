import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import openfl.display.Shape;
import openfl.display.GradientType;
import openfl.display.SpreadMethod;
import openfl.display.InterpolationMethod;
import openfl.geom.Matrix;
import openfl.display.BlendMode;

var lightOverlay:FlxSprite;
var fadeTween:FlxTween;

// Color palette sequence
var colorList:Array<Int> = [
    0xE02222, // Vivid Red
    0xA81919, // Dark Crimson
    0xFF0AC0, // Hot Pink / Magenta
    0x8C5D7F, // Muted Purple
    0x838C5D  // Sage Green
];

var colorIndex:Int = 0;

function postCreate() {
    // 1. HUD Light Overlay Setup
    lightOverlay = new FlxSprite(0, 0);
    lightOverlay.makeGraphic(FlxG.width, FlxG.height, 0x00000000);
    lightOverlay.scrollFactor.set(0, 0);
    lightOverlay.blend = BlendMode.ADD;
    lightOverlay.cameras = [camHUD]; // Render over full screen HUD
    lightOverlay.alpha = 0.0;
    
    add(lightOverlay);
}

/**
 * Redraws vertical bottom-heavy gradient and border vignette
 */
function redrawGradient(colorRGB:Int) {
    var shape:Shape = new Shape();
    var width:Float = FlxG.width;
    var height:Float = FlxG.height;

    // 1. VERTICAL BOTTOM-TO-TOP GRADIENT
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

    // 2. CENTERED BORDER VIGNETTE
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

    // Clear and re-render onto sprite
    lightOverlay.pixels.fillRect(lightOverlay.pixels.rect, 0x00000000);
    lightOverlay.pixels.draw(shape);
}

/**
 * Creates an expanding, fading silhouette outline copy behind a character
 * that updates animation frames live as the character sings
 */
/**
 * Creates an expanding, fading silhouette outline copy behind a character
 * that updates animation frames and animation offsets live as the character sings
 */
function spawnOutlinePulse(char:Dynamic, colorRGB:Int, duration:Float) {
    if (char == null || char.graphic == null) return;

    // Create clone sprite
    var pulse:FlxSprite = new FlxSprite(char.x, char.y);
    pulse.frames = char.frames;
    
    if (char.animation.curAnim != null) {
        pulse.animation.copyFrom(char.animation);
        pulse.animation.play(char.animation.curAnim.name, true, false, char.animation.curAnim.curFrame);
    }

    // Mirror basic transforms
    pulse.flipX = char.flipX;
    pulse.flipY = char.flipY;
    pulse.scale.set(char.scale.x, char.scale.y);
    pulse.updateHitbox();

    // Helper closure to dynamically sync animation offsets
    var syncOffsets = function() {
        if (char == null || pulse == null) return;
        
        var curAnimName:String = char.animation.curAnim != null ? char.animation.curAnim.name : "";
        
        // 1. Check Codename/Funkin Character animOffsets map (Map<String, Array<Float>>)
        if (Reflect.hasField(char, "animOffsets") && char.animOffsets != null && char.animOffsets.exists(curAnimName)) {
            var offsets:Array<Float> = char.animOffsets.get(curAnimName);
            pulse.offset.set(offsets[0], offsets[1]);
        } 
        // 2. Fallback to standard sprite offset
        else {
            pulse.offset.set(char.offset.x, char.offset.y);
        }
    };

    // Apply initial animation offset
    syncOffsets();

    pulse.scrollFactor.set(char.scrollFactor.x, char.scrollFactor.y);
    pulse.cameras = char.cameras;

    // Tint and additive blending
    pulse.color = FlxColor.fromInt(colorRGB);
    pulse.blend = BlendMode.ADD;
    pulse.alpha = 0.8;

    // Insert behind character layer
    insert(members.indexOf(char), pulse);

    // Target scale expansion (+20%)
    var startScaleX:Float = char.scale.x;
    var startScaleY:Float = char.scale.y;
    var targetScaleX:Float = startScaleX * 1.20;
    var targetScaleY:Float = startScaleY * 1.20;

    // Scale tween
    FlxTween.tween(pulse.scale, {x: targetScaleX, y: targetScaleY}, duration, {ease: FlxEase.quadOut});
    
    // Alpha tween with live frame & offset synchronization
    FlxTween.tween(pulse, {alpha: 0.0}, duration, {
        ease: FlxEase.quadOut,
        onUpdate: function(t:FlxTween) {
            if (char != null && pulse != null && pulse.exists) {
                // Live sync position
                pulse.x = char.x;
                pulse.y = char.y;
                
                // Live sync animation frame
                if (char.animation.curAnim != null && pulse.animation.curAnim != null) {
                    if (pulse.animation.curAnim.name != char.animation.curAnim.name) {
                        pulse.animation.play(char.animation.curAnim.name, true, false, char.animation.curAnim.curFrame);
                    } else {
                        pulse.animation.curAnim.curFrame = char.animation.curAnim.curFrame;
                    }
                }

                // Live sync active animation offsets
                syncOffsets();
            }
        },
        onComplete: function(t:FlxTween) {
            pulse.destroy(); // Cleanup
        }
    });
}

/**
 * Triggers instant flash to 1.0 alpha and spawns character outline pulses
 */
function flashPulse(duration:Float = 0.45) {
    if (lightOverlay == null) return;

    // Advance color sequence
    var currentColor:Int = colorList[colorIndex];
    colorIndex = (colorIndex + 1) % colorList.length;

    // 1. Redraw and flash HUD light overlay
    redrawGradient(currentColor);
    if (fadeTween != null) fadeTween.cancel();

    lightOverlay.alpha = 1.0;
    fadeTween = FlxTween.tween(lightOverlay, {alpha: 0.0}, duration, {
        ease: FlxEase.quadOut
    });

    // 2. Spawn live-tracking outline shockwaves on characters
    if (dad != null) spawnOutlinePulse(dad, currentColor, duration);
    if (boyfriend != null) spawnOutlinePulse(boyfriend, currentColor, duration);
}

function beatHit(curBeat:Int) {
    // Active window: Beat 184 up to Beat 215
    if (curBeat >= 184 && curBeat < 216) {
        flashPulse(0.45);
    } 
    // Clean stop at Beat 216
    else if (curBeat == 216) {
        if (fadeTween != null) fadeTween.cancel();
        lightOverlay.alpha = 0.0;
    }
}