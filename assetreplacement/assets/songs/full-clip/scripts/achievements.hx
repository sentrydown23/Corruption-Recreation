// Variable Init
var ach1 = FlxG.save.data.ach_fullclip_complete;
var ach2 = FlxG.save.data.ach_fullclip_fc;
var ach3 = FlxG.save.data.ach_fullclip_pfc;

function beatHit(curBeat:Int) {
    if (curBeat == 385) {
        achHandler();
    }
}

function achHandler() {
    if (!ach1) {
        FlxG.save.data.ach_fullclip_complete = true;
        grantAch("ach_fullclip_complete");
        if (misses == 0) FlxG.save.data.ach_fullclip_fc = true;
        if (misses == 0 && accuracy == 1) FlxG.save.data.ach_fullclip_pfc = true;
    } else {
        if (!ach3 && misses == 0 && accuracy == 1) {
            FlxG.save.data.ach_fullclip_pfc = true;
            FlxG.save.data.ach_fullclip_fc = true; // fc is pfc but worse
            grantAch("ach_fullclip_pfc");
        } else if (!ach2 && misses == 0) {
            FlxG.save.data.ach_fullclip_pfc = true;
            grantAch("ach_fullclip_fc");
        }
    }
    FlxG.save.flush();
}



function grantAch(ach:String) {
    achievementToUnlock = ach;
    showAchievement = true;
}