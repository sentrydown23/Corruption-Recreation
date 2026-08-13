// doIconBop = false;
// defaultDisplayRating = false;
// defaultDisplayCombo = false;
// minDigitDisplay = -1;

var gameoverState = GameOverSubstate;
var pauseState = PauseSubState;

function postCreate() {
    if (FlxG.save.data.kadearrows) {
        for (strum in cpuStrums.members) {
            strum.playAnim('static', true);
            strum.animation.callback = null;
        }
    }

    switch(SONG.meta.name)
    {
        case "frostbite", "tormentor", "neuroses", "discharge", "memoryleak", "senpai-remix", "dead-pixel", "treacherous-thorns", "roots":

        default:
            gameoverState.script = "data/scripts/gameover-normal";
    }   
}

if (FlxG.save.data.kadearrows) {
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
} // i hate this guy