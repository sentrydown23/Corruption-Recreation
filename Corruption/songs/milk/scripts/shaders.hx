import funkin.backend.shaders.CustomShader;
import openfl.filters.ShaderFilter;

var rainShader:CustomShader;
var dropletShader:CustomShader;

var rainFilter:ShaderFilter;
var dropletFilter:ShaderFilter;

var shaderTime:Float = 0;
var rainTime:Float = 0;
var rainControl:Float = 0;
var lightning:Float = 0;

function postCreate() {
    rainShader = new CustomShader("rain");
    dropletShader = new CustomShader("raindrops");
    
    rainShader.uScale = 1.0;
    rainShader.uRainControl = 0.0;
    rainShader.uRainTime = 0.0;
    
    dropletShader.uScale = 1.0;
    dropletShader.uRainControl = 0.0;
    dropletShader.uRainTime = 0.0;
    dropletShader.uLightning = 0.0;
    
    rainFilter = new ShaderFilter(rainShader);
    dropletFilter = new ShaderFilter(dropletShader);
    
    FlxG.camera.filtersEnabled = true;
    camHUD.filtersEnabled = true;

    FlxG.camera.setFilters([rainFilter, dropletFilter]);
    camHUD.setFilters([rainFilter]);
}

function beatHit(_) {
    if (_ % 16 == 0 && _ > 0) {
        triggerLightning();
    }

    switch (_) {
        case 12:
            tweenRain(0.6, 2.0, FlxEase.sineOut);

        case 80:
            tweenRain(0.2, 0.5, FlxEase.sineOut);

        case 112:
            tweenRain(0.4, 0.5, FlxEase.sineOut);

        case 144:
            tweenRain(0.2, 0.5, FlxEase.sineOut);

        case 183:
            tweenRain(0.0, 0.5, FlxEase.sineOut);
    } 
}

function triggerLightning() {
    lightning = 1.2;
    var soundName:String = FlxG.random.bool() ? "thunder_1" : "thunder_2";
    FlxG.sound.play(Paths.sound(soundName));
}

function update(elapsed:Float) {
    shaderTime += elapsed;
    rainTime += elapsed * (rainControl * 600.0);

    if (lightning > 0) {
        lightning = Math.max(0.0, lightning - elapsed * 4.0);
    }

    if (rainShader != null) {
        rainShader.uTime = shaderTime;
        rainShader.uRainTime = rainTime;
        rainShader.uRainControl = rainControl;
    }

    if (dropletShader != null) {
        dropletShader.uTime = shaderTime;
        dropletShader.uRainTime = rainTime;
        dropletShader.uRainControl = rainControl;
        dropletShader.uLightning = lightning;
    }
}

function tweenRain(targetValue:Float, duration:Float, ?ease:Dynamic):FlxTween {
    if (rainShader == null && dropletShader == null) return null;

    var startVal:Float = rainControl;

    return FlxTween.num(startVal, targetValue, duration, {
        ease: ease != null ? ease : FlxEase.linear,
        onUpdate: function(t:FlxTween) {
            rainControl = t.value;
        }
    });
}