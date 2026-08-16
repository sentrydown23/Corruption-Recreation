function stepHit(curStep:Int) {
    if (health <= 0.5 && FlxG.save.data.ach_low_health != true) {
        FlxG.save.data.ach_low_health = true;
        FlxG.save.flush();
        grantAch("ach_low_health");
    }
}

function onPlayerHit(event) {
    if(combo == 200 && FlxG.save.data.ach_high_combo != true) {
        FlxG.save.data.ach_high_combo = true;
        FlxG.save.flush();
        grantAch("ach_high_combo");
    }
}

function onGameOver() {
    if (FlxG.save.data.ach_death != true) {
        FlxG.save.data.ach_death = true;
        FlxG.save.flush();
        grantAch("ach_death");
    }
}

function grantAch(ach:String) {
    achievementToUnlock = ach;
    showAchievement = true;
}