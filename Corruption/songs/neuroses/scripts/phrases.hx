import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

var phrases:Array<FlxSprite> = [];
var phrase1:FlxSprite = new FlxSprite();
var phrase2:FlxSprite = new FlxSprite();
var phrase3:FlxSprite = new FlxSprite();
var phrase4:FlxSprite = new FlxSprite();
var phrase5:FlxSprite = new FlxSprite();
var phrase6:FlxSprite = new FlxSprite();
var phrase7:FlxSprite = new FlxSprite();

var isPhraseAllowed:Bool = false;

function postCreate() 
{
    createPhrases();

    phrases.push(phrase1);
    phrases.push(phrase2);
    phrases.push(phrase3);
    phrases.push(phrase4);
    phrases.push(phrase5);
    phrases.push(phrase6);
    phrases.push(phrase7);

    for (spr in phrases) {
        spr.alpha = 0;
        spr.visible = false;
    }
}

function beatHit(_)
{
    switch(_)
    {
        case 64:
            playPhrase(1);

        case 136:
            playPhrase(2);
        
        case 209:
            playPhrase(3);

        case 232:
            playPhrase(4);

        case 320:
            playPhrase(5);

        case 360:
            playPhrase(6);

        case 446:
            playPhrase(7);
    }
}

function playPhrase(number:Int) {
    if (number < 1 || number > 7) return;
    var targetPhrase = phrases[number - 1];
    if (targetPhrase == null) return;

    cleanupPhrases();
    isPhraseAllowed = true;

    targetPhrase.visible = true;

    FlxTween.tween(targetPhrase, {alpha: 1}, 0.3, {
        ease: FlxEase.quadOut,
        onComplete: function(twn1:FlxTween) {
            if (!isPhraseAllowed) return;

            new FlxTimer().start(0.05, function(tmr:FlxTimer) {
                if (!isPhraseAllowed) return;

                FlxTween.tween(targetPhrase, {alpha: 0}, 0.2, {
                    ease: FlxEase.quadIn,
                    onComplete: function(twn2:FlxTween) {
                        if (isPhraseAllowed) cleanupPhrases();
                    }
                });
            });
        }
    });
}

function cleanupPhrases() {
    isPhraseAllowed = false;

    for (phrase in phrases) {
        if (phrase != null) {
            FlxTween.globalManager.cancelTweensOf(phrase);
            phrase.alpha = 0;
            phrase.visible = false;
        }
    }
}

function createPhrases()
{
    phrase1.loadGraphic(Paths.image("stages/screen/neuroses/dialogue/text1"));
    phrase1.scrollFactor.set(0, 0);
    phrase1.screenCenter();
    phrase1.cameras = [camHUD];
    add(phrase1);

    phrase2.loadGraphic(Paths.image("stages/screen/neuroses/dialogue/text2"));
    phrase2.scrollFactor.set(0, 0);
    phrase2.screenCenter();
    phrase2.cameras = [camHUD];
    add(phrase2);

    phrase3.loadGraphic(Paths.image("stages/screen/neuroses/dialogue/text3"));
    phrase3.scrollFactor.set(0, 0);
    phrase3.screenCenter();
    phrase3.cameras = [camHUD];
    add(phrase3);

    phrase4.loadGraphic(Paths.image("stages/screen/neuroses/dialogue/text4"));
    phrase4.scrollFactor.set(0, 0);
    phrase4.screenCenter();
    phrase4.cameras = [camHUD];
    add(phrase4);

    phrase5.loadGraphic(Paths.image("stages/screen/neuroses/dialogue/text5"));
    phrase5.scrollFactor.set(0, 0);
    phrase5.screenCenter();
    phrase5.cameras = [camHUD];
    add(phrase5);

    phrase6.loadGraphic(Paths.image("stages/screen/neuroses/dialogue/text6"));
    phrase6.scrollFactor.set(0, 0);
    phrase6.screenCenter();
    phrase6.cameras = [camHUD];
    add(phrase6);

    phrase7.loadGraphic(Paths.image("stages/screen/neuroses/dialogue/text7"));
    phrase7.scrollFactor.set(0, 0);
    phrase7.screenCenter();
    phrase7.cameras = [camHUD];
    add(phrase7);
}