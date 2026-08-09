var currentSkinPath:String = "game/notes/default"; 

function stepHit(curStep:Int) {
    if (curStep == 320) {
        currentSkinPath = "game/notes/spippy";
        rebuildStrumLine(strumLines.members[0]);
    }
}

function onNoteCreation(e) {
    if (e.strumLine == strumLines.members[0]) {
        e.sprite = currentSkinPath; 
    }
}

function onStrumCreation(e) {
    if (e.strumLine == strumLines.members[0]) {
        e.sprite = currentSkinPath;
    }
}

function rebuildStrumLine(strumLine) {
    if (strumLine == null) return;

    // 1. Completely remove and destroy old receptors from the rendering group
    for (strum in strumLine.members) {
        if (strum != null) {
            strumLine.remove(strum, true);
            strum.destroy();
        }
    }
    strumLine.members = [];

    // 2. Rebuild the 4 arrows manually with intro animation set to false
    for (i in 0...4) {
        // Parameters: index, animPrefix, spritePath, playIntroAnimation
        // We set playIntroAnimation to false to force instant generation
        var newStrum = strumLine.createStrum(i, null, currentSkinPath, false);
        
        if (newStrum != null) {
            // Push it back into the StrumLine group array natively
            strumLine.add(newStrum);
        }
    }
}

