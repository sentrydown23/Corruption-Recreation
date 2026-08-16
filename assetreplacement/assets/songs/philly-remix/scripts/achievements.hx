// Variable Init
var ach1 = FlxG.save.data.ach_philly_complete;
var ach2 = FlxG.save.data.ach_philly_fc;
var ach3 = FlxG.save.data.ach_philly_pfc;
var ach4 = FlxG.save.data.ach_philly_nonote;

var picoNotesHit:Int = 0;

function onNoteHit(event) {
    if (event.noteType == "PicoNote") {
        picoNotesHit += 1;
    }
}

function beatHit(curBeat:Int) {
    if (curBeat == 560) {
        achHandler();
    }
}

function achHandler() {
    if(!ach4 && picoNotesHit == 0) {
        FlxG.save.data.ach_philly_nonote = true;
        if (ach1) grantAch("ach_philly_nonote");
    }

    if (!ach1) {
        FlxG.save.data.ach_philly_complete = true;
        grantAch("ach_philly_complete");
        if (misses == 0) FlxG.save.data.ach_philly_fc = true;
        if (misses == 0 && accuracy == 1) FlxG.save.data.ach_philly_pfc = true;
    } else {
        if (!ach3 && misses == 0 && accuracy == 1) {
            FlxG.save.data.ach_philly_pfc = true;
            FlxG.save.data.ach_philly_fc = true;
            grantAch("ach_philly_pfc");
        } else if (!ach2 && misses == 0) {
            FlxG.save.data.ach_philly_fc = true;
            grantAch("ach_philly_fc");
        }
    }
    FlxG.save.flush();
}



function grantAch(ach:String) {
    achievementToUnlock = ach;
    showAchievement = true;
}