// Variable Init
var ach1 = FlxG.save.data.ach_neuroses_complete;
var ach2 = FlxG.save.data.ach_neuroses_fc;
var ach3 = FlxG.save.data.ach_neuroses_pfc;

function beatHit(curBeat:Int) {
    if (curBeat == 536) {
        achHandler();
    }
}

function achHandler() {
    if (!ach1) {
        FlxG.save.data.ach_neuroses_complete = true;
        grantAch("ach_neuroses_complete");
        if (misses == 0) FlxG.save.data.ach_neuroses_fc = true;
        if (misses == 0 && accuracy == 1) FlxG.save.data.ach_neuroses_pfc = true;
    } else {
        if (!ach3 && misses == 0 && accuracy == 1) {
            FlxG.save.data.ach_neuroses_pfc = true;
            FlxG.save.data.ach_neuroses_fc = true;
            grantAch("ach_neuroses_pfc");
        } else if (!ach2 && misses == 0) {
            FlxG.save.data.ach_neuroses_fc = true;
            grantAch("ach_neuroses_fc");
        }
    }
    FlxG.save.flush();
}

function grantAch(ach:String) {
    achievementToUnlock = ach;
    showAchievement = true;
}