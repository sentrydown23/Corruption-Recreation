// Variable Init
var ach1 = FlxG.save.data.ach_chiller_complete;
var ach2 = FlxG.save.data.ach_chiller_fc;
var ach3 = FlxG.save.data.ach_chiller_pfc;

function beatHit(curBeat:Int) {
    if (curBeat == 321) {
        achHandler();
    }
}

function achHandler() {
    if (!ach1) {
        FlxG.save.data.ach_chiller_complete = true;
        grantAch("ach_chiller_complete");
        if (misses == 0) FlxG.save.data.ach_chiller_fc = true;
        if (misses == 0 && accuracy == 1) FlxG.save.data.ach_chiller_pfc = true;
    } else {
        if (!ach3 && misses == 0 && accuracy == 1) {
            FlxG.save.data.ach_chiller_pfc = true;
            FlxG.save.data.ach_chiller_fc = true; // fc is pfc but worse
            grantAch("ach_chiller_pfc");
        } else if (!ach2 && misses == 0) {
            FlxG.save.data.ach_chiller_fc = true;
            grantAch("ach_chiller_fc");
        }
    }
    FlxG.save.flush();
}

function grantAch(ach:String) {
    achievementToUnlock = ach;
    showAchievement = true;
}