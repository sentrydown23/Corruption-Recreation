static var hasSeenTitle:Bool = false;

function new() {
    // Set default values for save data if they are null
    if (FlxG.save.data.disParticles == null)
        FlxG.save.data.disParticles = true;
}