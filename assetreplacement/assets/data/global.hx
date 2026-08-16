import funkin.backend.assets.ModsFolder;

var targetMod:String = "Friday Night Funkin' CORRUPTION"; // Change to your target mod folder name

function update(elapsed:Float) {
    // Prevent infinite reload loops by checking if the target mod is already active
    if (ModsFolder.currentModFolder != targetMod) {
        // Option A: Automatically switch on game startup
        ModsFolder.switchMod(targetMod);

        /* 
        // Option B: Trigger keybind switch (e.g., Press F5)
        if (FlxG.keys.justPressed.F5) {
            ModsFolder.switchMod(targetMod);
        }
        */
    }
}