var phrases:Array<FlxSprite> = [];
var phrase1:FlxSprite = new FlxSprite();
var phrase2:FlxSprite = new FlxSprite();
var phrase3:FlxSprite = new FlxSprite();
var phrase4:FlxSprite = new FlxSprite();
var phrase5:FlxSprite = new FlxSprite();
var phrase6:FlxSprite = new FlxSprite();

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

    for (spr in phrases) {
        spr.alpha = 0;
        spr.visible = false;
    }
}

function beatHit(_)
{
    switch(_)
    {
        case 82:
            playPhrase(1);
        case 92:
            cleanupPhrases();

        case 108:
            playPhrase(2);
        case 118: 
            cleanupPhrases();

        case 180:
            playPhrase(3);
        case 190:
            cleanupPhrases();

        case 212:
            playPhrase(4);
        case 222:
            cleanupPhrases();

        case 344:
            playPhrase(5);
        case 354:
            cleanupPhrases();

        case 399:
            playPhrase(6);
    }
}

function playPhrase(number:Int) {
    if (number < 1 || number > 6) return;
    var targetPhrase = phrases[number - 1];
    if (targetPhrase == null) return;

    cleanupPhrases();
    isPhraseAllowed = true;

    targetPhrase.visible = true;

    FlxTween.tween(targetPhrase, {alpha: 1}, 1.0, {
        ease: FlxEase.quadOut,
        onComplete: function(twn1:FlxTween) {
            if (!isPhraseAllowed) return;

            new FlxTimer().start(1.0, function(tmr:FlxTimer) {
                if (!isPhraseAllowed) return;

                FlxTween.tween(targetPhrase, {alpha: 0}, 1.0, {
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
    var bfIndex:Int = members.indexOf(boyfriend);

    phrase1.loadGraphic(Paths.image("stages/frostbite/phrases/phrase1"));
    phrase1.scrollFactor.set(0, 0);
    phrase1.screenCenter();
    phrase1.cameras = [camHUD];
    insert(0, phrase1);

    phrase2.loadGraphic(Paths.image("stages/frostbite/phrases/phrase2"));
    phrase2.scale.set(0.7, 0.7);
    phrase2.updateHitbox();
    phrase2.scrollFactor.set(0, 0);
    phrase2.screenCenter();
    phrase2.cameras = [camHUD];
    insert(0, phrase2);

    phrase3.loadGraphic(Paths.image("stages/frostbite/phrases/phrase3"));
    phrase3.scale.set(0.6, 0.6);
    phrase3.updateHitbox();
    phrase3.scrollFactor.set(0, 0);
    phrase3.screenCenter();
    phrase3.cameras = [camHUD];
    insert(0, phrase3);

    phrase4.loadGraphic(Paths.image("stages/frostbite/phrases/phrase4"));
    phrase4.scale.set(1.1, 1.1);
    phrase4.updateHitbox();
    phrase4.scrollFactor.set(0, 0);
    phrase4.screenCenter();
    phrase4.cameras = [camGame];
    
    if (bfIndex != -1) {
        insert(bfIndex, phrase4);
    } else {
        add(phrase4);
    }

    phrase5.loadGraphic(Paths.image("stages/frostbite/phrases/phrase5"));
    phrase5.scrollFactor.set(0, 0);
    phrase5.screenCenter();
    phrase5.cameras = [camHUD];
    insert(0, phrase5);

    phrase6.loadGraphic(Paths.image("stages/frostbite/phrases/phrase6"));
    phrase6.scrollFactor.set(0, 0);
    phrase6.screenCenter();
    phrase6.cameras = [camHUD];
    insert(0, phrase6);
}
