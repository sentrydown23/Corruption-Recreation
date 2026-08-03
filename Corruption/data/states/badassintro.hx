import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import hxvlc.flixel.FlxVideoSprite;

var video:FlxVideoSprite;
var skipText:FlxText;
var skipTextTween:FlxTween;
var skipTextFlashTween:FlxTween;
var skipTextTimer:FlxTimer;
var isEnding:Bool = false;

function create() {
    if (FlxG.sound.music != null) {
        FlxG.sound.music.stop();
        FlxG.sound.music = null;
    }

    video = new FlxVideoSprite(0, 0);
    video.antialiasing = true;

    video.bitmap.onFormatSetup.add(function():Void {
        if (video.bitmap != null && video.bitmap.bitmapData != null) {
            final scale:Float = Math.min(FlxG.width / video.bitmap.bitmapData.width, FlxG.height / video.bitmap.bitmapData.height);
            video.setGraphicSize(video.bitmap.bitmapData.width * scale, video.bitmap.bitmapData.height * scale);
            video.updateHitbox();
            video.screenCenter();
        }
    });

    video.bitmap.onEndReached.add(function():Void {
        finishIntro();
    });

    add(video);

    skipText = new FlxText(0, 0, 0, "PRESS ENTER TO SKIP", 24);
    skipText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, "right");
    skipText.x = FlxG.width - skipText.width - 20;
    skipText.y = FlxG.height - skipText.height - 20;
    skipText.alpha = 0;
    add(skipText);

    if (video.load(Paths.video("badassintrovideo"))) {
        new FlxTimer().start(0.001, function(_) {
            video.play();
        });
    }
    hasSeenTitle = false;
}

function update(elapsed:Float) {
    if (FlxG.sound.music != null && FlxG.sound.music.playing) {
        FlxG.sound.music.stop();
        FlxG.sound.music = null;
    }

    if (isEnding) return;

    if (FlxG.keys.justPressed.ENTER) {
        finishIntro();
        return;
    }

    if (FlxG.keys.justPressed.ANY) {
        showSkipHint();
    }
}

function showSkipHint() {
    if (skipTextTween != null) skipTextTween.cancel();
    if (skipTextFlashTween != null) skipTextFlashTween.cancel();
    if (skipTextTimer != null) skipTextTimer.cancel();

    skipTextTween = FlxTween.tween(skipText, {alpha: 1}, 0.25, {
        ease: FlxEase.quadOut,
        onComplete: function(_) {
            skipTextFlashTween = FlxTween.tween(skipText, {alpha: 0.3}, 0.4, {
                type: FlxTween.PINGPONG
            });

            skipTextTimer = new FlxTimer().start(5.0, function(_) {
                if (skipTextFlashTween != null) skipTextFlashTween.cancel();
                if (skipTextTween != null) skipTextTween.cancel();
                skipTextTween = FlxTween.tween(skipText, {alpha: 0}, 0.5);
            });
        }
    });
}

function finishIntro() {
    if (isEnding) return;
    isEnding = true;

    if (video != null) {
        video.destroy();
    }

    FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function() {
        FlxG.switchState(new ModState("warning"));
    });
}