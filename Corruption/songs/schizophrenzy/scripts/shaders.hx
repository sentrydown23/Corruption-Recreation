import funkin.backend.shaders.CustomShader;
import openfl.filters.ShaderFilter;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var rainShader:CustomShader;
var dropletShader:CustomShader;
var blurShader:CustomShader;

var rainFilter:ShaderFilter;
var dropletFilter:ShaderFilter;
var blurFilter:ShaderFilter;

var shaderTime:Float = 0;
var rainTime:Float = 0;
var rainControl:Float = 0;
var lightning:Float = 0;
var blurAmount:Float = 2.0;

function postCreate() {
    blurShader = new CustomShader("blur");
    blurShader.uBlur = 1.0;
    blurFilter = new ShaderFilter(blurShader);

    rainShader = new CustomShader("rain");
    rainShader.uScale = 1.0;
    rainShader.uRainControl = 0.0;
    rainShader.uRainTime = 0.0;
    rainFilter = new ShaderFilter(rainShader);

    dropletShader = new CustomShader("raindrops");
    dropletShader.uScale = 1.0;
    dropletShader.uRainControl = 0.0;
    dropletShader.uRainTime = 0.0;
    dropletShader.uLightning = 0.0;
    dropletFilter = new ShaderFilter(dropletShader);

    FlxG.camera.filtersEnabled = true;
    camHUD.filtersEnabled = true;

    FlxG.camera.setFilters([blurFilter, rainFilter, dropletFilter]);
    camHUD.setFilters([blurFilter, rainFilter]);
}

function beatHit(_) {
    if (_ % 16 == 0 && _ > 0) {
        triggerLightning();
    }

    switch (_) 
    {
        case 36:
            tweenBlur(0.0, 2, FlxEase.expoIn);

        case 45:
            tweenBlur(0.0, 0.01);
            FlxG.camera.setFilters([rainFilter, dropletFilter]);
            camHUD.setFilters([rainFilter]);

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

    if (blurShader != null) {
        blurShader.uBlur = blurAmount;
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

function tweenBlur(targetValue:Float, duration:Float, ?ease:Dynamic):FlxTween {
    if (blurShader == null) return null;

    return FlxTween.num(blurAmount, targetValue, duration, {
        ease: ease != null ? ease : FlxEase.linear,
        onUpdate: function(t:FlxTween) {
            blurAmount = t.value;
        }
    });
}