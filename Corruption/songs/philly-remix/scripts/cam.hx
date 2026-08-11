var switched:Bool = false;

function create()
{
    blackBox = new FlxSprite(0, 0);
    blackBox.makeGraphic(5000, 5000, 0xFF000000);
    blackBox.screenCenter();
    blackBox.scrollFactor.set(0, 0);
    blackBox.cameras = [camHUD];
    add(blackBox);
}

function postCreate() 
{
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    startSong();
}

function onCountdown(event) {
   event.cancel();
}

function beatHit(_)
{
    switch(_)
    {
        case 1:
            tweenTo(blackBox, {alpha: 0}, 5);
        case 12:
            setToMiddleScroll(0.5);

        case 80: 
            resetStrumlines(0.5);

        case 284:
            setToMiddleScroll(0.5);

        case 336: 
            resetStrumlines(0.5);

        case 464:
            setToMiddleScroll(0.5);
        
        case 528:
            resetStrumlines(1);

        case 560:
            blackBox.alpha = 1;
    }
}

function setToMiddleScroll(duration:Float) {
    switched = true;
    
    var opponentStrum = strumLines.members[0]; // Opponent
    var playerStrum = strumLines.members[1];   // Player

    if (opponentStrum != null && playerStrum != null) {
        
        // 1. Smoothly glide Opponent to the center, then instantly make them invisible
        for (i in 0...opponentStrum.members.length) {
            var receptor = opponentStrum.members[i];
            if (receptor != null) {
                FlxTween.globalManager.cancelTweensOf(receptor);
                var targetX = 412 + (i * 112); 
                FlxTween.tween(receptor, {x: targetX}, duration, {
                    ease: FlxEase.quadOut,
                    onComplete: function(twn:FlxTween) {
                        // Swap: Opponent goes invisible, Player snaps in
                        receptor.alpha = 0;
                        
                        var pReceptor = playerStrum.members[i];
                        if (pReceptor != null) {
                            pReceptor.x = 412 + (i * 112);
                            pReceptor.alpha = 1;
                        }
                    }
                });
            }
        }
        
        // Fade out opponent's remaining visual notes
        for (note in opponentStrum.notes.members) {
            if (note != null) {
                FlxTween.globalManager.cancelTweensOf(note);
                FlxTween.tween(note, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            }
        }

        // 2. Smoothly fade the player's standard receptors on the right
        // Their positions will handle snapping to center in the onComplete above
        for (receptor in playerStrum.members) {
            if (receptor != null) {
                FlxTween.globalManager.cancelTweensOf(receptor);
                FlxTween.tween(receptor, {alpha: 0}, duration, {ease: FlxEase.quadOut});
            }
        }
    }
}

function resetStrumlines(duration:Float) {
    switched = false;
    
    var opponentStrum = strumLines.members[0]; // Opponent
    var playerStrum = strumLines.members[1];   // Player

    if (opponentStrum != null && playerStrum != null) {
        
        // 1. INSTANTLY switch receptor visibility back at center
        for (i in 0...playerStrum.members.length) {
            if (playerStrum.members[i] != null) playerStrum.members[i].alpha = 0;
            if (opponentStrum.members[i] != null) opponentStrum.members[i].alpha = 1;
        }

        // 2. FADE BACK IN any active opponent notes that were hidden
        for (note in opponentStrum.notes.members) {
            if (note != null) {
                FlxTween.globalManager.cancelTweensOf(note);
                FlxTween.tween(note, {alpha: 1}, duration, {ease: FlxEase.quadOut});
            }
        }

        // 3. Glide Opponent back to left side
        for (i in 0...opponentStrum.members.length) {
            var receptor = opponentStrum.members[i];
            if (receptor != null) {
                FlxTween.globalManager.cancelTweensOf(receptor);
                FlxTween.tween(receptor, {x: 92 + (i * 112)}, duration, {ease: FlxEase.quadOut});
            }
        }

        // 4. Glide Player back to right side while fading them back in
        for (i in 0...playerStrum.members.length) {
            var receptor = playerStrum.members[i];
            if (receptor != null) {
                FlxTween.globalManager.cancelTweensOf(receptor);
                receptor.x = 412 + (i * 112); // Ensure they start moving from center
                FlxTween.tween(receptor, {x: 732 + (i * 112), alpha: 1}, duration, {ease: FlxEase.quadOut});
            }
        }
    }
}

function onNoteCreation(event) {
    var opponentStrum = strumLines.members[0];
    var playerStrum = strumLines.members[1];

    if (switched) {
        if (event.strumLine == playerStrum) event.note.alpha = 1;
        if (event.strumLine == opponentStrum) event.note.alpha = 0;
    } else {
        if (event.strumLine == playerStrum) event.note.alpha = 1;
        if (event.strumLine == opponentStrum) event.note.alpha = 1;
    }
}

function tweenTo(object:Dynamic, values:Dynamic, duration:Float, options:Dynamic = null) {
    if (object != null) {
        FlxTween.globalManager.cancelTweensOf(object);
        return FlxTween.tween(object, values, duration, options);
    }
    return null;
}
