import flixel.group.FlxTypedSpriteGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.game.HealthIcon;

static var hasSeenTitle:Bool = false;

static var showAchievement:Bool = false;
static var achievementToUnlock:String = "";

// Refactored for Source Code cheating

static var achievements:Array<Dynamic> = [
    {
        saveKey: "ach_low_health",
        title: "MUST CONTINUE",
        desc: "Even as your vision fades, your mission remains the same.",
        icon: "bf-corrupted",
        isLosing: true
    },
    {
        saveKey: "ach_death",
        title: "GAME OVER",
        desc: "You lose.",
        icon: "bf-corrupted",
        isLosing: true
    },
    {
        saveKey: "ach_high_combo",
        title: "HIGH COMBO",
        desc: "Achieved a Combo of 200",
        icon: "bf-corrupted",
        isLosing: false
    },


    {
        saveKey: "ach_welcome",
        title: "CORRUPTION",
        desc: "Take back your life.",
        icon: "bf",
        isLosing: false
    },
    {
        saveKey: "ach_intro",
        title: "HOLY ANIMATION",
        desc: "What is this, an Anime!?",
        icon: "bf",
        isLosing: true
    },
    {
        saveKey: "ach_philly_nonote",
        title: "TOO LAZY",
        desc: "Miss all of Pico's notes. Hey, it's an advantage, right?",
        icon: "pico2",
        isLosing: true
    },
];

function new() {
    initStandardAch();
}

function initStandardAch() {
    var songList:Array<Dynamic> = [
        { key: "frostbite",        name: "FROSTBITE",            icon: "monster-frostbite",   desc: "How disappointing. ." },
    
        { key: "pico",             name: "PICO",                 icon: "pico1",               desc: "How have you been, friend?" },
        { key: "philly",           name: "PHILLY",               icon: "pico2",               desc: "He has to be. . ." },
        { key: "fullclip",         name: "FULL CLIP",            icon: "pico3",               desc: "You couldn't stop it." },
    
        { key: "spookeez",         name: "SPOOKEEZ",             icon: "spooky",              desc: "Innocence is bliss." },
        { key: "south",            name: "SOUTH",                icon: "spooky2",             desc: "Almost there." },
        { key: "chiller",          name: "CHILLER",              icon: "spooky3",             desc: "Best season of the year." },
    
        { key: "matricidal",       name: "MATRICIDAL",           icon: "mom",                 desc: "Must Murder Mommy." },
        { key: "milk",             name: "M.I.L.K.",             icon: "mom2",                desc: "Heavy rain is disheartening. . ." },
        { key: "schizophrenzy",    name: "SCHIZOPHRENZY",        icon: "mom3",                desc: "You're weak for a Dearest." },

        { key: "senpai",           name: "SENPAI",               icon: "senpai",              desc: "Console.Write(\"I am coming. =)\")" },
        { key: "deadpixel",        name: "DEAD PIXEL",           icon: "senpai",              desc: "Console.Write(\"She's not here anymore.\")" },
        { key: "tthorns",          name: "TREACHEROUS THORNS",   icon: "senpai2",             desc: "Console.Write(\"This is your fate.\")" },
        { key: "roots",            name: "ROOTS",                icon: "spirit2",             desc: "Console.Write(\"All of our roots die eventually, even yours.\")" },

        { key: "lament",           name: "LAMENT",               icon: "dad-lament-1",        desc: "You're the last one." },
        { key: "dusk",             name: "DUSK",                 icon: "dad-dusk-2",          desc: "Wouldn't have it any other way." },
        { key: "deathmatch",       name: "DEATHMATCH",           icon: "dad-dm-1",            desc: "It is done." },

        { key: "tormentor",        name: "TORMENTOR",            icon: "soul",                desc: "WAKE UP" },
        { key: "neuroses",         name: "NEUROSES",             icon: "soul",                desc: "Where'd you go. . ." },
        { key: "discharge",        name: "DISCHARGE",            icon: "soul",                desc: "Take back your life." },
        { key: "memoryleak",       name: "MEMORY // LEAK",       icon: "soul",                desc: "Hell of a send off, if you ask me." },
    
    ];

    for (song in songList) {
        // 1. Completion
        achievements.push({
            saveKey: "ach_" + song.key + "_complete",
            title: song.name,
            desc: song.desc,
            icon: song.icon,
            isLosing: false
        });

        // 2. Full Combo
        achievements.push({
            saveKey: "ach_" + song.key + "_fc",
            title: song.name + " FC",
            desc: "Achieve a Full Combo on " + song.name,
            icon: song.icon,
            isLosing: false
        });

        // 3. Perfect Full Combo
        achievements.push({
            saveKey: "ach_" + song.key + "_pfc",
            title: song.name + " PFC",
            desc: "Achieve a Perfect Full Combo on " + song.name,
            icon: song.icon,
            isLosing: true
        });
    }

    trace("=== TOTAL ACHIEVEMENTS REGISTERED: " + achievements.length + " ===");
    for (i in 0...achievements.length) {
        var ach = achievements[i];
        trace("Index " + i + " -> Key: " + ach.saveKey + " | Title: " + ach.title + " | Icon: " + ach.icon + " | Losing: " + ach.isLosing);
    }
    trace("========================================");
}

function update(elapsed:Float) {
    if (FlxG.save == null || FlxG.save.data == null) return;

    if (showAchievement) {
        showAchievement = false;
        triggerAchievementByKey(achievementToUnlock);
    } else if (FlxG.save.data.showAchievement == true) {
        FlxG.save.data.showAchievement = false;
        triggerAchievementByKey(FlxG.save.data.achievementToUnlock);
    }
}

function triggerAchievementByKey(key:String) {
    for (ach in achievements) {
        if (ach.saveKey == key) {
            var losingState:Bool = ach.isLosing == true;
            showAchievementPopup(ach.title, ach.desc, ach.icon, losingState);
            break;
        }
    }
}

function showAchievementPopup(titleText:String, descText:String, iconName:String, isLosing:Bool = false) {
    var boxWidth:Float = 420;
    var boxHeight:Float = 90;
    var startX:Float = (FlxG.width - boxWidth) / 2;

    var popup = new FlxSpriteGroup(startX, -boxHeight - 20);

    var bg = new FlxSprite().makeGraphic(Std.int(boxWidth), Std.int(boxHeight), 0xFF000000);
    bg.alpha = 0.3;
    popup.add(bg);

    var title = new FlxText(15, 12, boxWidth - 110, titleText);
    title.setFormat(null, 16, 0xFFFFFFFF, "left");
    popup.add(title);

    var desc = new FlxText(15, 38, boxWidth - 110, descText);
    desc.setFormat(null, 12, 0xCCCCCC, "left");
    popup.add(desc);

    var icon = new HealthIcon(iconName, false);

    if (isLosing) {
        if (icon.animation.getByName("losing") != null) {
            icon.animation.play("losing");
        } else if (icon.animation.curAnim != null) {
            icon.animation.curAnim.curFrame = 1;
        }
    }

    icon.scale.set(0.6, 0.6);
    icon.updateHitbox();
    icon.x = bg.width - icon.width - 15;
    icon.y = (bg.height - icon.height) / 2;
    popup.add(icon);

    var cam = new FlxCamera();
    cam.bgColor = 0x00000000;
    FlxG.cameras.add(cam, false);
    popup.cameras = [cam];

    var soundAsset = Paths.sound('achievement');
    if (soundAsset != null) {
        FlxG.sound.play(soundAsset, 0.7);
    }

    FlxG.state.add(popup);

    FlxTween.tween(popup, {y: 20}, 0.5, {
        ease: FlxEase.backOut,
        onComplete: function(twn:FlxTween) {
            FlxTween.tween(popup, {y: 20}, 2.5, {
                onComplete: function(twn:FlxTween) {
                    FlxTween.tween(popup, {y: -boxHeight - 20}, 0.5, {
                        ease: FlxEase.backIn,
                        onComplete: function(twn:FlxTween) {
                            popup.destroy();
                            FlxG.cameras.remove(cam, true);
                        }
                    });
                }
            });
        }
    });
}