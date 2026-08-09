var text1:FlxSprite;
var text2:FlxSprite;
var text3:FlxSprite;
var text4:FlxSprite;
var text5:FlxSprite;
var text6:FlxSprite;
var text7:FlxSprite;
var text8:FlxSprite;
var text9:FlxSprite;
var text10:FlxSprite;
var text11:FlxSprite;
var text12:FlxSprite;

function createTextSprite(path:String):FlxSprite {
    var spr:FlxSprite = new FlxSprite(0, 0);
    spr.loadGraphic(Paths.image("stages/screen/memoryleak/dialogue/" + path));
    spr.alpha = 0.001;
    spr.cameras = [camHUD];
    add(spr);
    return spr;
}

function postCreate() {
    text1 = createTextSprite("text1");
    text2 = createTextSprite("text2");
    text3 = createTextSprite("text3");
    text4 = createTextSprite("text4");
    text5 = createTextSprite("text5");
    text6 = createTextSprite("text6");
    text7 = createTextSprite("text7");
    text8 = createTextSprite("text8");
    text9 = createTextSprite("text9");
    text10 = createTextSprite("text10");
    text11 = createTextSprite("text11");
    text12 = createTextSprite("text12");
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 41:
            fadeText(text1, 1.0);
        case 57:
            fadeText(text1, 0.0, true);

        case 96:
            fadeText(text2, 1.0);
        case 103:
            fadeText(text2, 0.0, true);

        case 114:
            fadeText(text3, 1.0);
        case 132:
            fadeText(text3, 0.0, true);

        case 145:
            fadeText(text4, 1.0);
        case 161:
            fadeText(text4, 0.0, true);

        case 190:
            fadeText(text5, 1.0);
        case 215:
            fadeText(text5, 0.0, true);

        case 246:
            fadeText(text6, 1.0);
        case 268:
            fadeText(text6, 0.0, true);

        case 296:
            fadeText(text7, 1.0);
        case 302:
            fadeText(text7, 0.0, true);

        case 318:
            fadeText(text8, 1.0);
        case 341:
            fadeText(text8, 0.0, true);

        case 369:
            fadeText(text9, 1.0);
        case 378:
            fadeText(text9, 0.0, true);

        case 770:
            fadeText(text10, 1.0);
        case 778:
            fadeText(text10, 0.0, true);

        case 2224:
            fadeText(text11, 1.0);
        case 2236:
            fadeText(text11, 0.0, true);

        case 2248:
            fadeText(text12, 1.0);
        case 2260:
            fadeText(text12, 0.0, true);
    }
}

function fadeText(sprite:FlxSprite, targetAlpha:Float, destroyOnComplete:Bool = false) {
    if (sprite == null) return;

    FlxTween.tween(sprite, {alpha: targetAlpha}, 0.2, {
        ease: FlxEase.quadIn,
        onComplete: function(t:FlxTween) {
            if (destroyOnComplete) {
                sprite.destroy();
                remove(sprite, true);
            }
        }
    });
}