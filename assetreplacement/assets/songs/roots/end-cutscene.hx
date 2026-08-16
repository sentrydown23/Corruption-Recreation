import funkin.game.PlayState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;

function create() {
    // 1. Create a massive black box covering the full screen
    var blackBg:FlxSprite = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, 0xFF000000);
    blackBg.screenCenter();
    blackBg.scrollFactor.set(0, 0);
    blackBg.alpha = 0; // Start completely see-through
    add(blackBg);      // Add it directly to the cutscene state view layer
    
    // Define your XML path
    var songFolder = PlayState.SONG.meta.name.toLowerCase();
    var xmlPath = 'songs/' + songFolder + '/end-dialogue.xml';

    // 2. Fade in the black box smoothly over 1.0 second
    if (PlayState.instance != null && PlayState.instance.camHUD != null) {
        FlxTween.tween(PlayState.instance.camHUD, {alpha: 0}, 1.0);
    }
    FlxTween.tween(blackBg, {alpha: 1}, 1.0, {
        onComplete: function(tween:FlxTween) {
            
            // 3. Start the dialogue text box ONLY after the fade finishes
            startDialogue(xmlPath, function() {
                close(); // Safely exit the cutscene to proceed to results screen
            });
            
        }
    });
}
