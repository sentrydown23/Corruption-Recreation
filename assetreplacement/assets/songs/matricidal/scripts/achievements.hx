// Variable Init
var ach1 = FlxG.save.data.ach_matricidal_complete;
var ach2 = FlxG.save.data.ach_matricidal_fc;
var ach3 = FlxG.save.data.ach_matricidal_pfc;

function beatHit(curBeat:Int) {
    if (curBeat == 241) {
        achHandler();
    }
}

function achHandler() {
    if (!ach1) {
        FlxG.save.data.ach_matricidal_complete = true;
        grantAch("ach_matricidal_complete");
        if (misses == 0) FlxG.save.data.ach_matricidal_fc = true;
        if (misses == 0 && accuracy == 1) FlxG.save.data.ach_matricidal_pfc = true;
    } else {
        if (!ach3 && misses == 0 && accuracy == 1) {
            FlxG.save.data.ach_matricidal_pfc = true;
            FlxG.save.data.ach_matricidal_fc = true;
            grantAch("ach_matricidal_pfc");
        } else if (!ach2 && misses == 0) {
            FlxG.save.data.ach_matricidal_fc = true;
            grantAch("ach_matricidal_fc");
        }
    }
    FlxG.save.flush();
}

function grantAch(ach:String) {
    achievementToUnlock = ach;
    showAchievement = true;
}