import funkin.backend.shaders.CustomShader;
import openfl.filters.ShaderFilter;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var rainShader:CustomShader;
var shaderFilter:ShaderFilter;
var shaderTime:Float = 0;
var rainTime:Float = 0;
var rainControl:Float = 0;

var blurShader:CustomShader;
var blurFilter:ShaderFilter;
var blurAmount:Float = 2.0;

function postCreate() {
    blurShader = new CustomShader("blur");
    blurShader.uBlur = 1.0;
    blurFilter = new ShaderFilter(blurShader);


    rainShader = new CustomShader("rain");
    
    rainShader.uScale = 1.0;
    rainShader.uRainControl = 0.0; // Adjust speed and density together
    rainShader.uRainTime = 0.0;
    
    shaderFilter = new ShaderFilter(rainShader);
    
    // 1. Enable filters on both cameras
    FlxG.camera.filtersEnabled = true;
    camHUD.filtersEnabled = true;

    // 2. Apply shader filter to both the main game camera AND HUD camera
    FlxG.camera.setFilters([blurFilter, shaderFilter]);
    camHUD.setFilters([blurFilter, shaderFilter]);
}

function beatHit(_) {
    switch (_) 
    {
        case 36:
            tweenBlur(0.0, 2, FlxEase.expoIn);

        case 45:
            tweenBlur(0.0, 0.01); // ONLY FOR TESTING
            FlxG.camera.setFilters([shaderFilter]);
            camHUD.setFilters([shaderFilter]);

        case 71:
            tweenRain(0.3, 0.5, FlxEase.sineOut);

        case 103:
            tweenRain(0.5, 0.5, FlxEase.sineOut);

        case 168:
            tweenBlur(0.0, 2, FlxEase.expoIn);

        case 200:
            tweenRain(0.3, 0.5, FlxEase.sineOut);

        case 216:
            tweenRain(2.0, 6.0, FlxEase.sineOut);

        case 231:
            tweenRain(0.5, 0.5, FlxEase.sineOut);

    } 
}

function update(elapsed:Float) {
    if (rainShader != null) {
        shaderTime += elapsed;
        rainShader.uTime = shaderTime;

        // Continuously integrate rain falling offset using active rainControl
        rainTime += elapsed * (rainControl * 600.0);

        // Pass updated time and control values to shader
        rainShader.uRainTime = rainTime;
        rainShader.uRainControl = rainControl;
    }

    if (blurShader != null) {
        // Sync shader uniform to local tracked variable
        blurShader.uBlur = blurAmount;
    }
}

function tweenRain(targetValue:Float, duration:Float, ?ease:Dynamic):FlxTween {
    if (rainShader == null) return null;

    var startVal:Float = rainControl;

    return FlxTween.num(startVal, targetValue, duration, {
        ease: ease != null ? ease : FlxEase.linear,
        onUpdate: function(t:FlxTween) {
            // Update local script variable so update() reads the tweened value
            rainControl = t.value;
        }
    });
}

function tweenBlur(targetValue:Float, duration:Float, ?ease:Dynamic):FlxTween {
    if (blurShader == null) return null;

    return FlxTween.num(blurAmount, targetValue, duration, {
        ease: ease != null ? ease : FlxEase.linear,
        onUpdate: function(t:FlxTween) {
            blurAmount = t.value;
        }
    });
}