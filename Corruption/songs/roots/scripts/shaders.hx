import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var gameShader:CustomShader = null;
var hudShader:CustomShader = null;

var baseIntensity:Float = 2.0;
var currentIntensity:Float = 2.0;
var pulseAmount:Float = 12.0;

// Track active tweens to prevent overlaps
var baseIntensityTween:FlxTween = null;
var pulseAmountTween:FlxTween = null;

function postCreate() {
    if (!Options.gameplayShaders) return;

    // Separate instances prevent rendering collisions between game and HUD
    gameShader = new CustomShader('chromaticAbb');
    hudShader = new CustomShader('chromaticAbb');

    applyShaderStrength(baseIntensity);

    if (camGame != null) camGame.addShader(gameShader);
    if (camHUD != null) camHUD.addShader(hudShader);
}

function applyShaderStrength(val:Float) {
    currentIntensity = val;

    if (gameShader != null) gameShader.strength = currentIntensity;
    if (hudShader != null) hudShader.strength = currentIntensity;
}

function update(elapsed:Float) {
    if (!Options.gameplayShaders) return;

    // Smoothly decay intensity back down to the base value after bumps
    if (currentIntensity > baseIntensity) {
        applyShaderStrength(FlxMath.lerp(currentIntensity, baseIntensity, elapsed * 8));
    }
}

function triggerPulse(amount:Float) {
    if (!Options.gameplayShaders) return;
    applyShaderStrength(currentIntensity + amount);
}

// Helper to smoothly transition base intensity and pulse amounts over time
function tweenShaderSettings(targetBase:Float, targetPulse:Float, duration:Float = 0.5) {
    if (baseIntensityTween != null) baseIntensityTween.cancel();
    if (pulseAmountTween != null) pulseAmountTween.cancel();

    baseIntensityTween = FlxTween.num(baseIntensity, targetBase, duration, {ease: FlxEase.sineOut}, function(val:Float) {
        baseIntensity = val;
    });

    pulseAmountTween = FlxTween.num(pulseAmount, targetPulse, duration, {ease: FlxEase.sineOut}, function(val:Float) {
        pulseAmount = val;
    });
}

function beatHit(curBeat:Float) {
    switch(curBeat)
    {
        case 96: 
            tweenShaderSettings(4.0, 16.0, 0.5);

        case 128:
            tweenShaderSettings(9.0, 21.0, 0.5);

        case 160:
            tweenShaderSettings(2.0, 12.0, 0.5);

        case 224:
            tweenShaderSettings(15.0, 50.0, 0.5);

        case 352:
            tweenShaderSettings(0.0, 0.0, 0.5);
    }

    if (curBeat % 2 == 0) {
        triggerPulse(pulseAmount);
    }
}