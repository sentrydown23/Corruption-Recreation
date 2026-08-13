import flixel.addons.effects.FlxTrail;
import flixel.system.FlxSound;

var bgSprite:FlxSprite;
var lowHealthSprite:FlxSprite;
var staticSprite:FlxSprite;
var bfSprite:FlxSprite;
var bfTrail:FlxTrail;
var deathSound:FlxSound;
var retrySound:FlxSound;
var deathMusic:FlxSound;
var lowHealthTween:FlxTween;
var canRestart:Bool = false;
var isEnding:Bool = false;
var zoomDone:Bool = false;

var bpm:Float = 95;
var crochet:Float = (60 / 95) * 1000;
var lastBeat:Int = -1;

function create(event) {
    event.cancel();

    FlxTween.cancelTweensOf(FlxG.camera);
    FlxTween.cancelTweensOf(FlxG.camera.scroll);
    FlxG.camera.target = null;
    FlxG.camera.scroll.set(0, 0);
    FlxG.camera.zoom = 1;

    bgSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("hurtvin"));
    bgSprite.setGraphicSize(Std.int(FlxG.width * 1.5), Std.int(FlxG.height * 1.5));
    bgSprite.updateHitbox();
    bgSprite.screenCenter();
    bgSprite.scrollFactor.set(0, 0);
    add(bgSprite);

    lowHealthSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("lowhealth"));
    lowHealthSprite.setGraphicSize(Std.int(FlxG.width * 1.5), Std.int(FlxG.height * 1.5));
    lowHealthSprite.updateHitbox();
    lowHealthSprite.screenCenter();
    lowHealthSprite.scrollFactor.set(0, 0);
    lowHealthSprite.cameras = [FlxG.camera];
    lowHealthSprite.alpha = 0;
    add(lowHealthSprite);

    lowHealthTween = FlxTween.tween(lowHealthSprite, {alpha: 1}, 1.5, {type: FlxTween.PINGPONG, ease: FlxEase.quadInOut});

    bfSprite = new FlxSprite(0, 0);
    bfSprite.frames = Paths.getSparrowAtlas("characters/bf-corrupted");
    bfSprite.animation.addByPrefix("dead", "BF Dead Loop", 24, false);
    bfSprite.animation.addByPrefix("miss", "BF NOTE LEFT MISS", 24, false);
    bfSprite.animation.play("dead", true);
    bfSprite.scrollFactor.set(0, 0);
    bfSprite.screenCenter();
    bfSprite.y += 150;

    bfTrail = new FlxTrail(bfSprite, null, 5, 3, 0.5, 0.08);
    bfTrail.scrollFactor.set(0, 0);
    bfTrail.visible = bfSprite.visible;
    bfTrail.active = bfSprite.visible;
    add(bfTrail);

    add(bfSprite);

    staticSprite = new FlxSprite(0, 0);
    staticSprite.frames = Paths.getSparrowAtlas("menus/static");
    staticSprite.animation.addByPrefix("idle", "static idle dance", 24, true);
    staticSprite.animation.play("idle");
    staticSprite.setGraphicSize(FlxG.width, FlxG.height);
    staticSprite.updateHitbox();
    staticSprite.screenCenter();
    staticSprite.scrollFactor.set(0, 0);
    add(staticSprite);

    deathSound = FlxG.sound.play(Paths.sound("gameover-normal"));

    new FlxTimer().start(2.0, function(tmr:FlxTimer) {
        FlxTween.tween(FlxG.camera, {zoom: 1.25}, 0.4, {
            ease: FlxEase.quadOut,
            onComplete: function(t:FlxTween) {
                FlxTween.tween(FlxG.camera, {zoom: 0.75}, 2.2, {
                    ease: FlxEase.sineInOut,
                    onComplete: function(t:FlxTween) {
                        zoomDone = true;
                    }
                });
            }
        });

        FlxTween.tween(staticSprite, {alpha: 0}, 1.2, {ease: FlxEase.quadOut});

        if (deathSound != null) {
            deathSound.fadeOut(1.2, 0);
        }

        deathMusic = FlxG.sound.play(Paths.music("gameover-normal"), 0, true);
        deathMusic.fadeIn(1.2, 0, 1);

        canRestart = true;
    });
}

function update(elapsed:Float) {
    if (bfTrail != null && bfSprite != null) {
        bfTrail.visible = bfSprite.visible;
        bfTrail.active = bfSprite.visible;

        if (bfTrail.members != null) {
            for (i in 0...bfTrail.members.length) {
                var spr = bfTrail.members[i];
                if (spr != null && spr.exists) {
                    var scaleOffset = 1.0 + (i * 0.025);
                    spr.scale.set(scaleOffset, scaleOffset);
                }
            }
        }
    }

    if (deathMusic != null && deathMusic.playing && !isEnding) {
        var curBeat:Int = Math.floor(deathMusic.time / crochet);
        if (curBeat > lastBeat) {
            lastBeat = curBeat;
            bfSprite.animation.play("dead", true);

            if (zoomDone && curBeat % 4 == 0) {
                FlxG.camera.zoom = 0.78;
                FlxTween.tween(FlxG.camera, {zoom: 0.75}, 0.65, {ease: FlxEase.sineOut});
            }
        }
    }

    if (canRestart && !isEnding && FlxG.keys.justPressed.ENTER) {
        isEnding = true;
        canRestart = false;

        if (deathMusic != null) {
            deathMusic.stop();
        }

        FlxTween.cancelTweensOf(FlxG.camera);

        bfSprite.animation.play("miss");
        if (bfSprite.animation.curAnim != null) {
            bfSprite.animation.curAnim.curFrame = bfSprite.animation.curAnim.numFrames - 1;
        }
        bfSprite.animation.pause();

        FlxG.camera.zoom = 1.1;
        FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom * 1.08}, 0.5, {ease: FlxEase.sineOut});

        staticSprite.alpha = 1;
        staticSprite.animation.play("idle");
        retrySound = FlxG.sound.play(Paths.sound("gameover-normal"));

        new FlxTimer().start(0.4, function(tmr:FlxTimer) {
            FlxTween.tween(staticSprite, {alpha: 0}, 0.5, {
                ease: FlxEase.quadOut,
                onComplete: function(t:FlxTween) {
                    if (retrySound != null) {
                        retrySound.stop();
                    }

                    FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom * 1.25}, 1.4, {ease: FlxEase.sineInOut});

                    FlxG.camera.fade(0xFF000000, 1.4, false, function() {
                        FlxG.switchState(new PlayState());
                    });
                }
            });
        });
    }
}