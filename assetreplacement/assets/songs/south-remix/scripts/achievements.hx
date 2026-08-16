// Variable Init
var ach1 = FlxG.save.data.ach_south_complete;
var ach2 = FlxG.save.data.ach_south_fc;
var ach3 = FlxG.save.data.ach_south_pfc;

function beatHit(curBeat:Int) {
    if (curBeat == 225) {
        achHandler();
    }
}

function achHandler() {
    if (!ach1) {
        FlxG.save.data.ach_south_complete = true;
        grantAch("ach_south_complete");
        if (misses == 0) FlxG.save.data.ach_south_fc = true;
        if (misses == 0 && accuracy == 1) FlxG.save.data.ach_south_pfc = true;
    } else {
        if (!ach3 && misses == 0 && accuracy == 1) {
            FlxG.save.data.ach_south_pfc = true;
            FlxG.save.data.ach_south_fc = true; // fc is pfc but worse
            grantAch("ach_south_pfc");
        } else if (!ach2 && misses == 0) {
            FlxG.save.data.ach_south_fc = true;
            grantAch("ach_south_fc");
        }
    }
    FlxG.save.flush();
}

function grantAch(ach:String) {
    achievementToUnlock = ach;
    showAchievement = true;
}