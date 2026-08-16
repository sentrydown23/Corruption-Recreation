import funkin.game.PlayState;
import funkin.backend.shaders.CustomShader; 
import openfl.filters.ShaderFilter;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import Reflect;

// --- SHADER & FILTER ---
var beatShakeShader:CustomShader;
var cameraFilter:ShaderFilter;
var shaderTime:Float = 0;
var isShaderEnabled:Bool = true;

// --- TWEEN HANDLES ---
var shakeTween:FlxTween;
var blurTween:FlxTween;

// --- BLUR SETTINGS ---
var currentBlur:Float = 0.0;       // Live blur strength
var isBlurPingPonging:Bool = false;
var blurPulseSpeed:Float = 4.0;
var minBreathe:Float = 0.0005;
var maxBreathe:Float = 0.001;

// --- SHAKE SETTINGS ---
var shakeStrength:Float = 0.0;     // Active beat pulse decay (1.0 to 0.0)
var maxShakeStrength:Float = 0.0;  // Maximum screen shake intensity
var shakeBeat:Int = 4;             // Trigger pulse every N beats (1, 2, 4, etc.)

// --- CHROMATIC ABERRATION SETTINGS ---
var chromaticEnabled:Float = 0.0;   // 0.0 = OFF, 1.0 = ON
var shakePulseStrength:Float = 0.0; // RGB split intensity multiplier
var shakePulseJitter:Float = 0.0;   // Jitter amount (0.0 = Smooth, 1.0 = Jittery)

function create() {
    beatShakeShader = new CustomShader("fullclip-chrom"); 
    beatShakeShader.iTime = 0.0;
    
    cameraFilter = new ShaderFilter(beatShakeShader);
    FlxG.camera.setFilters([cameraFilter]);
}

function beatHit(curBeat:Int) {
    switch(curBeat)
    {
        case 28:
            doBlurTween(0.005, 2);

        case 32: 
            isBlurPingPonging = true;

        case 62:
            isBlurPingPonging = false;
            doBlurTween(0.01, 1);

        case 64:
            isBlurPingPonging = true;
            blurPulseSpeed = 6.0;
            minBreathe = 0.001;
            maxBreathe = 0.002;
            
            chromaticEnabled = 1.0;
            shakeBeat = 1;
            maxShakeStrength = 0.9;
            shakePulseStrength = 3.0;
            shakePulseJitter = 1.0;

        case 96:
            shakeBeat = 2;
            maxShakeStrength = 0.4;
            shakePulseJitter = 0.0;
            shakePulseStrength = 1.0; 

        case 160:
            currentBlur = 0.0;
            isBlurPingPonging = false;
            blurPulseSpeed = 4.0;
            minBreathe = 0.0005;
            maxBreathe = 0.001;

        case 192:
            disableShader();

        case 256:
            enableShader(); // Re-enable through helper
            
            blurPulseSpeed = 6.0;
            minBreathe = 0.001;
            maxBreathe = 0.002;
            isBlurPingPonging = true;
            
            chromaticEnabled = 1.0;
            shakeBeat = 1;
            maxShakeStrength = 0.9;
            shakePulseStrength = 3.0;
            shakePulseJitter = 1.0;

            shakeStrength = 1.0;

        case 320:
            shakeBeat = 2;
            maxShakeStrength = 0.4;
            shakePulseJitter = 0.0;
            shakePulseStrength = 1.0; 

        case 384:
            disableShader();
    }

    // --- BEAT-PULSE TRIGGER ---
    if (isShaderEnabled && curBeat % shakeBeat == 0) {
        if (shakeTween != null) shakeTween.cancel();
        shakeStrength = 1.0; 

        shakeTween = FlxTween.num(1.0, 0.0, 0.4, {
            ease: FlxEase.linear,
            onUpdate: function(t:FlxTween) {
                shakeStrength = t.value; 
            }
        });
    }
}

function update(elapsed:Float) {
    if (beatShakeShader == null) return;

    shaderTime += elapsed;

    // --- BLUR PING-PONG OSCILLATOR ---
    if (isShaderEnabled && isBlurPingPonging) {
        var wave:Float = (Math.sin(shaderTime * blurPulseSpeed) + 1.0) * 0.5;
        currentBlur = minBreathe + (wave * (maxBreathe - minBreathe));
    }

    // --- PUSH ALL UNIFORMS IN ONE PLACE ---
    syncShaderUniforms([
        "iTime"               => shaderTime,
        "beatPulse"           => isShaderEnabled ? shakeStrength : 0.0,
        "customBlur"          => isShaderEnabled ? currentBlur : 0.0,
        "aberrationToggle"    => isShaderEnabled ? chromaticEnabled : 0.0,
        "shakeStrength"       => isShaderEnabled ? maxShakeStrength : 0.0,
        "aberrationIntensity" => isShaderEnabled ? shakePulseStrength : 0.0,
        "jitterAmount"        => isShaderEnabled ? shakePulseJitter : 0.0
    ]);
}

/**
 * Disables active shader rendering while maintaining parameter setup.
 */
function disableShader() {
    isShaderEnabled = false;
    isBlurPingPonging = false;
    
    // Kill running tweens
    if (shakeTween != null) {
        shakeTween.cancel();
        shakeTween = null;
    }
    if (blurTween != null) {
        blurTween.cancel();
        blurTween = null;
    }

    // Zero out live execution values
    shakeStrength = 0.0;
    currentBlur = 0.0;
}

/**
 * Re-enables the shader pipeline.
 */
function enableShader() {
    isShaderEnabled = true;
}

// Safely interpolates blur strength over time
function doBlurTween(targetAmount:Float, duration:Float) {
    if (!isShaderEnabled) return;
    if (blurTween != null) blurTween.cancel();

    blurTween = FlxTween.num(currentBlur, targetAmount, duration, {
        ease: FlxEase.quadOut,
        onUpdate: function(t:FlxTween) {
            currentBlur = t.value;
        }
    });
}

// Clean bulk update helper
function syncShaderUniforms(uniforms:Map<String, Float>) {
    if (beatShakeShader == null || beatShakeShader.data == null) return;
    
    for (name => value in uniforms) {
        var param = Reflect.field(beatShakeShader.data, name);
        if (param != null) {
            Reflect.setProperty(param, "value", [value]);
        }
    }
}