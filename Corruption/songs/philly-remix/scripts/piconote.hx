var customTypeName:String = "PicoNote"; 

function onPlayerHit(event) {
    if (event.noteType == customTypeName) {
        event.note.strumLine.deleteNote(event.note);

        songScore += event.score;
        combo += 1;
        if (splashHandler != null && event.note != null && event.note.__strum != null) {
            splashHandler.showSplash(event.note.splash, event.note.__strum);
        }
        event.cancel();
        var playerStrum = strumLines.members[1]; // 1 is the Player strumline
            
        if (playerStrum != null) {
            var receptor = playerStrum.members[event.direction];
            if (receptor != null) {
                receptor.playAnim("confirm", true);
            }
        }
        health -= 0.1; 
        if (health < 0.5) health = 0.5;
    }
}

function onPlayerMiss(event) {
    if (event.noteType == customTypeName) {
        event.cancel();
        event.note.strumLine.deleteNote(event.note);
        songScore -= 10;
        misses += 1;     
        health += 0.05;
        if (health > 2) health = 2;
    }
}
