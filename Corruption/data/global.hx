static var hasSeenTitle:Bool = false;

function new() {
    // Set default values for save data if they are null
    if (FlxG.save.data.disParticles == null)
        FlxG.save.data.disParticles = true;

    if (FlxG.save.data.kadearrows == null)
        FlxG.save.data.kadearrows = true;

    if (FlxG.save.data.vigtoggle == null)
        FlxG.save.data.vigtoggle = true;

    if (FlxG.save.data.forcefull == null)
        FlxG.save.data.forcefull = false;
}