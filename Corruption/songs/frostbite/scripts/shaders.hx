import funkin.backend.shaders.CustomShader;
import openfl.filters.ShaderFilter;

var defaultShader:CustomShader = null;
var defaultTime:Float = 0;
var defaultGameFilter:ShaderFilter = null;
var defaultHudFilter:ShaderFilter = null;

function beatHit(_)
{
    switch(_)
    {
        case 212:
            defaultShaderApply();

        case 272:
            defaultShaderRemove();
    }
}

function update(elapsed:Float)
{
    if (defaultShader != null)
    {
        defaultTime += elapsed;
        
        var timeParam = Reflect.field(defaultShader.data, "iTime");
        if (timeParam != null) {
            Reflect.setProperty(timeParam, "value", [defaultTime]);
        }
    }
}

function defaultShaderApply()
{
    // Safety clean
    defaultShaderRemove();
    defaultShader = new CustomShader("frostbite-shake");
    defaultTime = 0; // Reset runtime cloc  
    defaultGameFilter = new ShaderFilter(defaultShader);
    defaultHudFilter = new ShaderFilter(defaultShader);
    // Apply to the Main Game Camera
    if (FlxG.camera.filters == null) {
        FlxG.camera.filters = [defaultGameFilter];
    } else {
        FlxG.camera.filters.push(defaultGameFilter);
    }

    // Apply to the HUD Camera
    if (camHUD != null) {
        if (camHUD.filters == null) {
            camHUD.filters = [defaultHudFilter];
        } else {
            camHUD.filters.push(defaultHudFilter);
        }
    }
}

function defaultShaderRemove()
{
    // Remove from the Main Game Camera
    if (FlxG.camera.filters != null && defaultGameFilter != null) {
        FlxG.camera.filters.remove(defaultGameFilter);
        if (FlxG.camera.filters.length == 0) {
            FlxG.camera.filters = null;
        }
    }

    // Remove from the HUD Camera
    if (camHUD != null && camHUD.filters != null && defaultHudFilter != null) {
        camHUD.filters.remove(defaultHudFilter);
        if (camHUD.filters.length == 0) {
            camHUD.filters = null;
        }
    }

    // Reset the variables
    defaultGameFilter = null;
    defaultHudFilter = null;
    defaultShader = null;
}