// Variable Init
var ach1 = FlxG.save.data.ach_pico_complete;
var ach2 = FlxG.save.data.ach_pico_fc;
var ach3 = FlxG.save.data.ach_pico_pfc;

function beatHit(curBeat:Int) {
    if (curBeat == 450) {
        achHandler();
    }
}

function achHandler() {
    if (!ach1) {
        FlxG.save.data.ach_pico_complete = true;
        grantAch("ach_pico_complete");
        if (misses == 0) FlxG.save.data.ach_pico_fc = true;
        if (misses == 0 && accuracy == 1) FlxG.save.data.ach_pico_pfc = true;
    } else {
        if (!ach3 && misses == 0 && accuracy == 1) {
            FlxG.save.data.ach_pico_pfc = true;
            FlxG.save.data.ach_pico_fc = true;
            grantAch("ach_pico_pfc");
        } else if (!ach2 && misses == 0) {
            FlxG.save.data.ach_pico_fc = true;
            grantAch("ach_pico_fc");
        }
    }
    FlxG.save.flush();
}

function grantAch(ach:String) {
    achievementToUnlock = ach;
    showAchievement = true;
}