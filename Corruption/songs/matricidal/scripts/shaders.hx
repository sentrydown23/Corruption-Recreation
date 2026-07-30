import funkin.backend.shaders.CustomShader;
import openfl.filters.ShaderFilter;

var rainShader:CustomShader;
var shaderFilter:ShaderFilter;
var shaderTime:Float = 0;
var rainTime:Float = 0;
var rainControl:Float = 0;

function postCreate() {
    rainShader = new CustomShader("rain");
    
    rainShader.uScale = 1.0;
    rainShader.uRainControl = 0.0; // Adjust speed and density together
    rainShader.uRainTime = 0.0;
    
    shaderFilter = new ShaderFilter(rainShader);
    
    // 1. Enable filters on both cameras
    FlxG.camera.filtersEnabled = true;
    camHUD.filtersEnabled = true;

    // 2. Apply shader filter to both the main game camera AND HUD camera
    FlxG.camera.setFilters([shaderFilter]);
    camHUD.setFilters([shaderFilter]);
}

function beatHit(_) {
    switch (_) 
    {
        case 41:
            tweenRain(0.6, 2.0, FlxEase.sineOut);

        case 74:
            tweenRain(0.8, 2.0, FlxEase.sineOut);

        case 161:
            tweenRain(0.6, 2.0, FlxEase.sineOut);

        case 194:
            tweenRain(0.8, 2.0, FlxEase.sineOut);

        case 226:
            tweenRain(0.2, 0.5, FlxEase.sineOut);

        case 242:
            FlxG.camera.filtersEnabled = false;
            camHUD.filtersEnabled = false;
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