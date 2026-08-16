if (Options.kadearrows == true) {
function postCreate() {
    for (strum in cpuStrums.members) {
        strum.playAnim('static', true);
        strum.animation.callback = null;
    }
}

function onNoteHit(event) {
    if (!event.player) {
        // Do NOT use event.cancel() so we can still utilize the default functionality -- Trill

        var note = event.note;
        
        // Make note go bye bye? - Scrally
        // Yes - Trill
        note.visible = false;

        // If it has a sustain tail, let it live in the background so the tail draws normally - Trill
        if (note.isSustainNote || note.childCanBeHit) {
            note.active = true;
        } else {
            // Headache curing
            note.kill();
            strumLines.members[note.strumLineID].notes.remove(note);
            note.destroy();
        }
    }
}

function onPostNoteHit(event) {
    if (!event.player) {
        // Not elegant but we ball
        var strum = cpuStrums.members[event.note.noteData];
        if (strum != null) {
            strum.playAnim('static', true);
        }
    }
}
}