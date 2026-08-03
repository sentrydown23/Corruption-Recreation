import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

// --- CARD SPEED & ANIMATION SETTINGS ---
var cardSlideTime:Float = 0.2; // Duration for card sliding in/out
var cardFadeTime:Float = 0.2;  // Duration for text/card alpha fades
var cardEaseOut = FlxEase.quartOut; // Easing for cards sliding IN
var cardEaseIn = FlxEase.quartIn;   // Easing for cards sliding OUT

var chains:FlxSprite;
var thankYou:FlxSprite;

var card1:FlxSprite;
var text1_1:FlxText;
var text1_2:FlxText;

var card2:FlxSprite;
var text2_1:FlxText;
var text2_2:FlxText;

var card3:FlxSprite;
var text3_1:FlxText;
var text3_2:FlxText;

var cardTargetX:Float = 0;
var cardTargetY:Float = 0;

var currentStep:Int = 0;
var canInteract:Bool = false;

var confirm:String = "menus/confirm";

function create() {
    if (FlxG.sound.music != null && FlxG.sound.music.playing) {
        FlxG.sound.music.stop();
        FlxG.sound.music = null;
    }

    chains = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/title/warnings/chains"));
    chains.screenCenter();
    chains.antialiasing = true;
    chains.alpha = 0;
    add(chains);

    thankYou = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/title/warnings/thankyou"));
    thankYou.screenCenter();
    thankYou.antialiasing = true;
    thankYou.alpha = 0;
    add(thankYou);

    var dummyCard = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/title/warnings/infoCard"));
    dummyCard.scale.set(0.75, 0.75);
    dummyCard.updateHitbox();
    dummyCard.screenCenter();
    cardTargetX = dummyCard.x;
    cardTargetY = dummyCard.y;
    dummyCard.destroy();

    setupCard1();
    setupCard2();
    setupCard3();

    // Background fade-in preserved (0.8s)
    FlxTween.tween(chains, {alpha: 1}, 0.8, {
        ease: FlxEase.quadOut,
        onComplete: function(_) {
            showCard1();
        }
    });
}

function setupCard1() {
    card1 = new FlxSprite(cardTargetX - 40, cardTargetY).loadGraphic(Paths.image("menus/title/warnings/infoCard"));
    card1.scale.set(0.75, 0.75);
    card1.updateHitbox();
    card1.antialiasing = true;
    card1.alpha = 0;
    add(card1);

    text1_1 = new FlxText(0, 0, card1.width - 200, "This game contains flashing imagery which may trigger epileptic seizures.", 35);
    text1_1.setFormat(Paths.font("Cardamon Regular.ttf"), 35, FlxColor.WHITE, "center");
    text1_1.alignment = "center";
    text1_1.antialiasing = true;
    text1_1.alpha = 0;

    text1_2 = new FlxText(0, 0, card1.width - 200, "I understand.", 35);
    text1_2.setFormat(Paths.font("Cardamon Regular.ttf"), 35, 0xFFF23A3A, "center");
    text1_2.alignment = "center";
    text1_2.antialiasing = true;
    text1_2.alpha = 0;

    var totalHeight:Float = text1_1.height + 20 + text1_2.height;
    var startY:Float = cardTargetY + (card1.height - totalHeight) / 2;

    text1_1.x = card1.x + (card1.width - text1_1.width) / 2;
    text1_1.y = startY;
    add(text1_1);

    text1_2.x = cardTargetX + (card1.width - text1_2.width) / 2;
    text1_2.y = text1_1.y + text1_1.height + 20;
    add(text1_2);
}

function setupCard2() {
    card2 = new FlxSprite(cardTargetX - 40, cardTargetY).loadGraphic(Paths.image("menus/title/warnings/infoCard"));
    card2.scale.set(0.75, 0.75);
    card2.updateHitbox();
    card2.antialiasing = true;
    card2.alpha = 0;
    add(card2);

    text2_1 = new FlxText(0, 0, card2.width - 200, "Original Friday Night Funkin' by The Funkin Crew Inc. ", 35);
    text2_1.setFormat(Paths.font("Cardamon Regular.ttf"), 35, FlxColor.WHITE, "center");
    text2_1.alignment = "center";
    text2_1.antialiasing = true;
    text2_1.alpha = 0;

    text2_2 = new FlxText(0, 0, card2.width - 200, "I understand.", 35);
    text2_2.setFormat(Paths.font("Cardamon Regular.ttf"), 35, 0xFFF23A3A, "center");
    text2_2.alignment = "center";
    text2_2.antialiasing = true;
    text2_2.alpha = 0;

    var totalHeight:Float = text2_1.height + 20 + text2_2.height;
    var startY:Float = cardTargetY + (card2.height - totalHeight) / 2;

    text2_1.x = card2.x + (card2.width - text2_1.width) / 2;
    text2_1.y = startY;
    add(text2_1);

    text2_2.x = cardTargetX + (card2.width - text2_2.width) / 2;
    text2_2.y = text2_1.y + text2_1.height + 20;
    add(text2_2);
}

function setupCard3() {
    card3 = new FlxSprite(cardTargetX - 40, cardTargetY).loadGraphic(Paths.image("menus/title/warnings/infoCard"));
    card3.scale.set(0.75, 0.75);
    card3.updateHitbox();
    card3.antialiasing = true;
    card3.alpha = 0;
    add(card3);

    text3_1 = new FlxText(0, 0, card3.width - 200, "Original Corruption Mod created by PhantomFear", 35);
    text3_1.setFormat(Paths.font("Cardamon Regular.ttf"), 35, FlxColor.WHITE, "center");
    text3_1.alignment = "center";
    text3_1.antialiasing = true;
    text3_1.alpha = 0;

    text3_2 = new FlxText(0, 0, card3.width - 200, "I understand.", 35);
    text3_2.setFormat(Paths.font("Cardamon Regular.ttf"), 35, 0xFFF23A3A, "center");
    text3_2.alignment = "center";
    text3_2.antialiasing = true;
    text3_2.alpha = 0;

    var totalHeight:Float = text3_1.height + 20 + text3_2.height;
    var startY:Float = cardTargetY + (card3.height - totalHeight) / 2;

    text3_1.x = card3.x + (card3.width - text3_1.width) / 2;
    text3_1.y = startY;
    add(text3_1);

    text3_2.x = cardTargetX + (card3.width - text3_2.width) / 2;
    text3_2.y = text3_1.y + text3_1.height + 20;
    add(text3_2);
}

function showCard1() {
    currentStep = 1;
    FlxTween.tween(card1, {x: cardTargetX, alpha: 1}, cardSlideTime, {ease: cardEaseOut});
    FlxTween.tween(text1_1, {x: cardTargetX + (card1.width - text1_1.width) / 2, alpha: 1}, cardSlideTime, {ease: cardEaseOut});

    new FlxTimer().start(cardSlideTime * 0.5, function(_) {
        FlxTween.tween(text1_2, {alpha: 0.6}, cardFadeTime, {
            onComplete: function(_) { canInteract = true; }
        });
    });
}

function transitionCard1To2() {
    canInteract = false;
    FlxTween.tween(card1, {x: cardTargetX + 80, alpha: 0}, cardSlideTime, {ease: cardEaseIn});
    FlxTween.tween(text1_1, {x: cardTargetX + 80 + (card1.width - text1_1.width) / 2, alpha: 0}, cardSlideTime, {ease: cardEaseIn});
    FlxTween.tween(text1_2, {x: cardTargetX + 80 + (card1.width - text1_2.width) / 2, alpha: 0}, cardSlideTime, {
        ease: cardEaseIn,
        onComplete: function(_) {
            showCard2();
        }
    });
}

function showCard2() {
    currentStep = 2;
    FlxTween.tween(card2, {x: cardTargetX, alpha: 1}, cardSlideTime, {ease: cardEaseOut});
    FlxTween.tween(text2_1, {x: cardTargetX + (card2.width - text2_1.width) / 2, alpha: 1}, cardSlideTime, {ease: cardEaseOut});

    new FlxTimer().start(cardSlideTime * 0.5, function(_) {
        FlxTween.tween(text2_2, {alpha: 0.6}, cardFadeTime, {
            onComplete: function(_) { canInteract = true; }
        });
    });
}

function transitionCard2To3() {
    canInteract = false;
    FlxTween.tween(card2, {x: cardTargetX + 80, alpha: 0}, cardSlideTime, {ease: cardEaseIn});
    FlxTween.tween(text2_1, {x: cardTargetX + 80 + (card2.width - text2_1.width) / 2, alpha: 0}, cardSlideTime, {ease: cardEaseIn});
    FlxTween.tween(text2_2, {x: cardTargetX + 80 + (card2.width - text2_2.width) / 2, alpha: 0}, cardSlideTime, {
        ease: cardEaseIn,
        onComplete: function(_) {
            showCard3();
        }
    });
}

function showCard3() {
    currentStep = 3;
    FlxTween.tween(card3, {x: cardTargetX, alpha: 1}, cardSlideTime, {ease: cardEaseOut});
    FlxTween.tween(text3_1, {x: cardTargetX + (card3.width - text3_1.width) / 2, alpha: 1}, cardSlideTime, {ease: cardEaseOut});

    new FlxTimer().start(cardSlideTime * 0.5, function(_) {
        FlxTween.tween(text3_2, {alpha: 0.6}, cardFadeTime, {
            onComplete: function(_) { canInteract = true; }
        });
    });
}

function finishSequence() {
    canInteract = false;
    currentStep = 4;

    FlxTween.tween(card3, {alpha: 0}, cardFadeTime);
    FlxTween.tween(text3_1, {alpha: 0}, cardFadeTime);
    FlxTween.tween(text3_2, {alpha: 0}, cardFadeTime, {
        onComplete: function(_) {
            // Outro sequence preserved at original slow speeds (1.0s)
            FlxTween.tween(thankYou, {alpha: 1}, 1.0, {
                onComplete: function(_) {
                    new FlxTimer().start(0.5, function(_) {
                        FlxTween.tween(chains, {alpha: 0}, 1.0, {
                            onComplete: function(_) {
                                FlxTween.tween(thankYou, {alpha: 0}, 1.0, {
                                    onComplete: function(_) {
                                        FlxG.switchState(new ModState("MainMenuStateC"));
                                    }
                                });
                            }
                        });
                    });
                }
            });
        }
    });
}

function update(elapsed:Float) {
    if (canInteract && FlxG.keys.justPressed.ENTER) {
        if (currentStep == 1) {
            transitionCard1To2();
            FlxG.sound.play(Paths.sound(confirm), 1);
        } else if (currentStep == 2) {
            transitionCard2To3();
            FlxG.sound.play(Paths.sound(confirm), 1);
        } else if (currentStep == 3) {
            finishSequence();
            FlxG.sound.play(Paths.sound(confirm), 1);
        }
    }
}