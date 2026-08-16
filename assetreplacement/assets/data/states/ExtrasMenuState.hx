import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.game.HealthIcon;

var currentMenuState:Int = 0;
var curCategorySelected:Int = 0;
var curWeekSelected:Int = 0;
var curSongSelected:Int = 0;
var curAchievementSelected:Int = 0;

var categoryData:Array<Dynamic> = [
    {
        name: "Song-Wide",
        subcategories: [],
        keys: ["ach_low_health", "ach_death", "ach_high_combo"]
    },
    {
        name: "Weeks",
        subcategories: [
            {
                name: "WINTER HORRLAND",
                subcategories: [
                    {
                        name: "Frostbite",
                        keys: ["ach_frostbite_complete", "ach_frostbite_fc", "ach_frostbite_pfc"]
                    }
                ]
            },
            {
                name: "IN MY WAY",
                subcategories: [
                    {
                        name: "Pico",
                        keys: ["ach_pico_complete", "ach_pico_fc", "ach_pico_pfc"]
                    },
                    {
                        name: "Philly",
                        keys: ["ach_philly_complete", "ach_philly_fc", "ach_philly_pfc", "ach_philly_nonote"]
                    },
                    {
                        name: "Full Clip",
                        keys: ["ach_fullclip_complete", "ach_fullclip_fc", "ach_fullclip_pfc"]
                    }
                ]
            },
            {
                name: "GOOD TIMES MUST END",
                subcategories: [
                    {
                        name: "Spookeez",
                        keys: ["ach_spookeez_complete", "ach_spookeez_fc", "ach_spookeez_pfc"]
                    },
                    {
                        name: "South",
                        keys: ["ach_south_complete", "ach_south_fc", "ach_south_pfc"]
                    },
                    {
                        name: "Chiller",
                        keys: ["ach_chiller_complete", "ach_chiller_fc", "ach_chiller_pfc"]
                    }
                ]
            },
            {
                name: "Must Murder Mommy",
                subcategories: [
                    {
                        name: "Matricidal",
                        keys: ["ach_matricidal_complete", "ach_matricidal_fc", "ach_matricidal_pfc"]
                    },
                    {
                        name: "M.I.L.K.",
                        keys: ["ach_milk_complete", "ach_milk_fc", "ach_milk_pfc"]
                    },
                    {
                        name: "Schizophrenzy",
                        keys: ["ach_schizophrenzy_complete", "ach_schizophrenzy_fc", "ach_schizophrenzy_pfc"]
                    }
                ]
            },
            {
                name: "DELETE",
                subcategories: [
                    {
                        name: "Senpai",
                        keys: ["ach_senpai_complete", "ach_senpai_fc", "ach_senpai_pfc"]
                    },
                    {
                        name: "Dead Pixel",
                        keys: ["ach_deadpixel_complete", "ach_deadpixel_fc", "ach_deadpixel_pfc"]
                    },
                    {
                        name: "Treacherous Thorns",
                        keys: ["ach_tthorns_complete", "ach_tthorns_fc", "ach_tthorns_pfc"]
                    },
                    {
                        name: "Roots",
                        keys: ["ach_roots_complete", "ach_roots_fc", "ach_roots_pfc"]
                    }
                ]
            },
            {
                name: "ONE LEFT",
                subcategories: [
                    {
                        name: "Lament",
                        keys: ["ach_lament_complete", "ach_lament_fc", "ach_lament_pfc"]
                    },
                    {
                        name: "Dusk",
                        keys: ["ach_dusk_complete", "ach_dusk_fc", "ach_dusk_pfc"]
                    },
                    {
                        name: "Deathmatch",
                        keys: ["ach_deathmatch_complete", "ach_deathmatch_fc", "ach_deathmatch_pfc"]
                    }
                ]
            },
            {
                name: "? ? ?",
                subcategories: [
                    {
                        name: "Tormentor",
                        keys: ["ach_tormentor_complete", "ach_tormentor_fc", "ach_tormentor_pfc"]
                    },
                    {
                        name: "Neuroses",
                        keys: ["ach_neuroses_complete", "ach_neuroses_fc", "ach_neuroses_pfc"]
                    },
                    {
                        name: "Discharge",
                        keys: ["ach_discharge_complete", "ach_discharge_fc", "ach_discharge_pfc"]
                    },
                    {
                        name: "Memory // Leak",
                        keys: ["ach_memoryleak_complete", "ach_memoryleak_fc", "ach_memoryleak_pfc"]
                    }
                ]
            }
        ],
        keys: []
    },
    {
        name: "Misc",
        subcategories: [],
        keys: ["ach_welcome", "ach_intro"]
    }
];

var filteredAchievements:Array<Dynamic> = [];

var menuGroup:FlxSpriteGroup;
var itemList:Array<FlxSpriteGroup> = [];
var titleText:FlxText;
var titleTween:FlxTween;

var bgGlitch:FlxSprite;
var bgBack:FlxSprite;
var menuShader:CustomShader;
var shaderTime:Float = 0;

var progressBarBG:FlxSprite;
var progressBarFill:FlxSprite;
var progressText:FlxText;
var targetProgressWidth:Float = 0;

function create() {
    if (FlxG.sound.music == null || FlxG.sound.music.name != Paths.music('extra')) {
        FlxG.sound.playMusic(Paths.music('extra'), 0.7);
    }

    bgBack = new FlxSprite().loadGraphic(Paths.image('menus/extras/back'));
    bgBack.scrollFactor.set(0, 0);
    bgBack.screenCenter();
    add(bgBack);

    bgGlitch = new FlxSprite().loadGraphic(Paths.image('menus/extras/glitch'));
    bgGlitch.scrollFactor.set(0, 0);
    bgGlitch.screenCenter();
    add(bgGlitch);

    var bgFront = new FlxSprite().loadGraphic(Paths.image('menus/extras/front'));
    bgFront.scrollFactor.set(0, 0);
    bgFront.screenCenter();
    add(bgFront);

    menuGroup = new FlxSpriteGroup();
    add(menuGroup);

    titleText = new FlxText(0, 40, FlxG.width, "");
    titleText.setFormat(null, 28, 0xFFFFFFFF, "center");
    titleText.scrollFactor.set(0, 0);
    add(titleText);

    initProgressBar();
    initMenuShader();

    openCategoryMenu();
}

function initProgressBar() {
    var barWidth:Int = 500;
    var barHeight:Int = 20;
    var barX:Float = (FlxG.width - barWidth) / 2;
    var barY:Float = FlxG.height - 50;

    progressBarBG = new FlxSprite(barX, barY).makeGraphic(barWidth, barHeight, 0xFF000000);
    progressBarBG.alpha = 0.6;
    progressBarBG.scrollFactor.set(0, 0);
    add(progressBarBG);

    progressBarFill = new FlxSprite(barX + 2, barY + 2).makeGraphic(1, barHeight - 4, 0xFFFFFFFF);
    progressBarFill.origin.set(0, 0);
    progressBarFill.scrollFactor.set(0, 0);
    add(progressBarFill);

    progressText = new FlxText(0, barY - 25, FlxG.width, "0% COMPLETED");
    progressText.setFormat(null, 16, 0xFFFFFFFF, "center");
    progressText.scrollFactor.set(0, 0);
    add(progressText);

    updateProgressData();
}

function updateProgressData() {
    var totalAchievements:Int = achievements.length;
    var unlockedCount:Int = 0;

    if (totalAchievements > 0) {
        for (ach in achievements) {
            if (FlxG.save.data != null && Reflect.field(FlxG.save.data, ach.saveKey) == true) {
                unlockedCount++;
            }
        }

        var percent:Float = (unlockedCount / totalAchievements) * 100;
        progressText.text = Math.floor(percent) + "% COMPLETED (" + unlockedCount + "/" + totalAchievements + ")";
        
        var maxFillWidth:Float = 496;
        targetProgressWidth = (unlockedCount / totalAchievements) * maxFillWidth;
    } else {
        progressText.text = "0% COMPLETED";
        targetProgressWidth = 0;
    }
}

function openCategoryMenu() {
    currentMenuState = 0;
    clearItems();
    
    updateTitle("SELECT CATEGORY");

    var spacing:Float = 110;
    var startY:Float = (FlxG.height / 2) - 40;

    for (i in 0...categoryData.length) {
        var cat = categoryData[i];
        var container = new FlxSpriteGroup((FlxG.width - 500) / 2, startY + (i * spacing));

        var box = new FlxSprite().makeGraphic(500, 80, 0xFF000000);
        box.alpha = 0.4;
        container.add(box);

        var catText = new FlxText(0, 25, 500, cat.name.toUpperCase());
        catText.setFormat(null, 22, 0xFFFFFFFF, "center");
        container.add(catText);

        container.x -= 120;
        container.alpha = 0;
        container.scale.set(0.85, 0.85);
        FlxTween.tween(container, {x: (FlxG.width - 500) / 2}, 0.35 + (i * 0.05), {ease: FlxEase.quartOut});

        menuGroup.add(container);
        itemList.push(container);
    }

    menuGroup.y = -curCategorySelected * spacing;
    changeSelection(0, false);
}

function openWeekMenu() {
    currentMenuState = 1;
    curWeekSelected = 0;
    clearItems();

    var cat = categoryData[curCategorySelected];
    updateTitle(cat.name.toUpperCase() + " - WEEKS");

    var weeks:Array<Dynamic> = cat.subcategories;
    var spacing:Float = 110;
    var startY:Float = (FlxG.height / 2) - 40;

    for (i in 0...weeks.length) {
        var week = weeks[i];
        var container = new FlxSpriteGroup((FlxG.width - 500) / 2, startY + (i * spacing));

        var box = new FlxSprite().makeGraphic(500, 80, 0xFF000000);
        box.alpha = 0.4;
        container.add(box);

        var weekText = new FlxText(0, 25, 500, week.name.toUpperCase());
        weekText.setFormat(null, 22, 0xFFFFFFFF, "center");
        container.add(weekText);

        container.x -= 120;
        container.alpha = 0;
        container.scale.set(0.85, 0.85);
        FlxTween.tween(container, {x: (FlxG.width - 500) / 2}, 0.35 + (i * 0.05), {ease: FlxEase.quartOut});

        menuGroup.add(container);
        itemList.push(container);
    }

    menuGroup.y = -curWeekSelected * spacing;
    changeSelection(0, false);
}

function openSongMenu() {
    currentMenuState = 2;
    curSongSelected = 0;
    clearItems();

    var week = categoryData[curCategorySelected].subcategories[curWeekSelected];
    updateTitle(week.name.toUpperCase() + " - SONGS");

    var songs:Array<Dynamic> = week.subcategories;
    var spacing:Float = 110;
    var startY:Float = (FlxG.height / 2) - 40;

    for (i in 0...songs.length) {
        var song = songs[i];
        var container = new FlxSpriteGroup((FlxG.width - 500) / 2, startY + (i * spacing));

        var box = new FlxSprite().makeGraphic(500, 80, 0xFF000000);
        box.alpha = 0.4;
        container.add(box);

        var songText = new FlxText(0, 25, 500, song.name.toUpperCase());
        songText.setFormat(null, 22, 0xFFFFFFFF, "center");
        container.add(songText);

        container.x -= 120;
        container.alpha = 0;
        container.scale.set(0.85, 0.85);
        FlxTween.tween(container, {x: (FlxG.width - 500) / 2}, 0.35 + (i * 0.05), {ease: FlxEase.quartOut});

        menuGroup.add(container);
        itemList.push(container);
    }

    menuGroup.y = -curSongSelected * spacing;
    changeSelection(0, false);
}

function openAchievementMenu() {
    currentMenuState = 3;
    curAchievementSelected = 0;
    clearItems();

    var cat = categoryData[curCategorySelected];
    var keysToLoad:Array<String> = [];
    var headerString:String = cat.name;

    if (cat.subcategories != null && cat.subcategories.length > 0) {
        var week = cat.subcategories[curWeekSelected];
        if (week.subcategories != null && week.subcategories.length > 0) {
            var song = week.subcategories[curSongSelected];
            headerString = week.name + " - " + song.name;
            keysToLoad = song.keys;
        } else {
            headerString = cat.name + " - " + week.name;
            keysToLoad = week.keys;
        }
    } else {
        keysToLoad = cat.keys;
    }

    updateTitle(headerString.toUpperCase());

    filteredAchievements = [];
    for (key in keysToLoad) {
        for (ach in achievements) {
            if (ach.saveKey == key) {
                filteredAchievements.push(ach);
                break;
            }
        }
    }

    var spacing:Float = 130;
    var startY:Float = (FlxG.height / 2) - 50;

    for (i in 0...filteredAchievements.length) {
        var data = filteredAchievements[i];
        var isUnlocked:Bool = FlxG.save.data != null && Reflect.field(FlxG.save.data, data.saveKey) == true;

        var container = new FlxSpriteGroup((FlxG.width - 500) / 2, startY + (i * spacing));

        var box = new FlxSprite().makeGraphic(500, 100, 0xFF000000);
        box.alpha = isUnlocked ? 0.5 : 0.25;
        container.add(box);

        var nameText = new FlxText(20, 15, 360, data.title);
        nameText.setFormat(null, 20, isUnlocked ? 0xFFFFFFFF : 0xFF666666, "left");
        container.add(nameText);

        if (isUnlocked) {
            var descText = new FlxText(20, 45, 360, data.desc);
            descText.setFormat(null, 14, 0xCCCCCC, "left");
            container.add(descText);
        } else {
            var lockText = new FlxText(20, 50, 360, "LOCKED");
            lockText.setFormat(null, 14, 0xFF444444, "left");
            container.add(lockText);
        }

        var icon = new HealthIcon(data.icon, false);
        if (data.isLosing == true) {
            if (icon.animation.getByName("losing") != null) {
                icon.animation.play("losing");
            } else if (icon.animation.curAnim != null) {
                icon.animation.curAnim.curFrame = 1;
            }
        }
        icon.scale.set(0.45, 0.45);
        icon.updateHitbox();
        icon.x = box.width - icon.width - 15;
        icon.y = (box.height - icon.height) / 2;

        if (!isUnlocked) {
            icon.color = 0xFF000000;
        }

        container.add(icon);

        container.x += 120;
        container.alpha = 0;
        container.scale.set(0.85, 0.85);
        FlxTween.tween(container, {x: (FlxG.width - 500) / 2}, 0.35 + (i * 0.05), {ease: FlxEase.quartOut});

        menuGroup.add(container);
        itemList.push(container);
    }

    menuGroup.y = -curAchievementSelected * spacing;
    changeSelection(0, false);
}

function updateTitle(newText:String) {
    if (titleTween != null) titleTween.cancel();
    
    FlxTween.tween(titleText, {y: 20, alpha: 0}, 0.15, {
        ease: FlxEase.quadIn,
        onComplete: function(t:FlxTween) {
            titleText.text = newText;
            titleText.y = 50;
            titleTween = FlxTween.tween(titleText, {y: 40, alpha: 1}, 0.25, {ease: FlxEase.quartOut});
        }
    });
}

function clearItems() {
    for (item in itemList) {
        FlxTween.cancelTweensOf(item);
        FlxTween.cancelTweensOf(item.scale);
        item.destroy();
    }
    itemList = [];
    menuGroup.clear();
}

function update(elapsed:Float) {
    shaderTime += elapsed;
    if (menuShader != null) {
        menuShader.iTime = shaderTime;
        if (Reflect.hasField(menuShader, "setFloat")) {
            menuShader.setFloat("iTime", shaderTime);
        }
    }

    if (progressBarFill != null) {
        var currentWidth:Float = progressBarFill.scale.x;
        var lerpWidth:Float = FlxMath.lerp(currentWidth, Math.max(1, targetProgressWidth), FlxMath.bound(elapsed * 8, 0, 1));
        progressBarFill.scale.x = lerpWidth;
    }

    if (controls.UP_P || FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W) {
        changeSelection(-1, true);
    }

    if (controls.DOWN_P || FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S) {
        changeSelection(1, true);
    }

    if (controls.ACCEPT || FlxG.keys.justPressed.ENTER) {
        FlxG.sound.play(Paths.sound('menus/confirm'));
        
        if (currentMenuState == 0) {
            var cat = categoryData[curCategorySelected];
            if (cat.subcategories != null && cat.subcategories.length > 0) {
                openWeekMenu();
            } else {
                openAchievementMenu();
            }
        } else if (currentMenuState == 1) {
            var week = categoryData[curCategorySelected].subcategories[curWeekSelected];
            if (week.subcategories != null && week.subcategories.length > 0) {
                openSongMenu();
            } else {
                openAchievementMenu();
            }
        } else if (currentMenuState == 2) {
            openAchievementMenu();
        }
    }

    if (controls.BACK || FlxG.keys.justPressed.ESCAPE) {
        FlxG.sound.play(Paths.sound('menus/cancel'));
        
        if (currentMenuState == 3) {
            var cat = categoryData[curCategorySelected];
            if (cat.subcategories != null && cat.subcategories.length > 0) {
                var week = cat.subcategories[curWeekSelected];
                if (week.subcategories != null && week.subcategories.length > 0) {
                    openSongMenu();
                } else {
                    openWeekMenu();
                }
            } else {
                openCategoryMenu();
            }
        } else if (currentMenuState == 2) {
            openWeekMenu();
        } else if (currentMenuState == 1) {
            openCategoryMenu();
        } else {
            FlxG.switchState(new MainMenuState());
        }
    }

    var targetY:Float = 0;
    if (currentMenuState == 0) {
        targetY = -curCategorySelected * 110;
    } else if (currentMenuState == 1) {
        targetY = -curWeekSelected * 110;
    } else if (currentMenuState == 2) {
        targetY = -curSongSelected * 110;
    } else if (currentMenuState == 3) {
        targetY = -curAchievementSelected * 130;
    }

    menuGroup.y = FlxMath.lerp(menuGroup.y, targetY, FlxMath.bound(elapsed * 22, 0, 1));

    var activeIndex:Int = curCategorySelected;
    if (currentMenuState == 1) activeIndex = curWeekSelected;
    if (currentMenuState == 2) activeIndex = curSongSelected;
    if (currentMenuState == 3) activeIndex = curAchievementSelected;

    var lerpSpeed:Float = FlxMath.bound(elapsed * 15, 0, 1);
    for (i in 0...itemList.length) {
        var item = itemList[i];
        var dist:Float = Math.abs(i - activeIndex);

        var targetScale:Float = Math.max(0.8, 1.04 - (dist * 0.08));
        var targetAlpha:Float = Math.max(0.35, 1.0 - (dist * 0.25));

        item.scale.x = FlxMath.lerp(item.scale.x, targetScale, lerpSpeed);
        item.scale.y = FlxMath.lerp(item.scale.y, targetScale, lerpSpeed);
        item.alpha = FlxMath.lerp(item.alpha, targetAlpha, lerpSpeed);
    }
}

function changeSelection(change:Int, playSound:Bool = true) {
    if (playSound && change != 0) {
        FlxG.sound.play(Paths.sound('menus/scroll'));
    }

    var maxItems:Int = 0;
    if (currentMenuState == 0) maxItems = categoryData.length;
    else if (currentMenuState == 1) maxItems = categoryData[curCategorySelected].subcategories.length;
    else if (currentMenuState == 2) maxItems = categoryData[curCategorySelected].subcategories[curWeekSelected].subcategories.length;
    else if (currentMenuState == 3) maxItems = filteredAchievements.length;

    if (maxItems == 0) return;

    if (currentMenuState == 0) {
        curCategorySelected += change;
        if (curCategorySelected < 0) curCategorySelected = maxItems - 1;
        if (curCategorySelected >= maxItems) curCategorySelected = 0;
    } else if (currentMenuState == 1) {
        curWeekSelected += change;
        if (curWeekSelected < 0) curWeekSelected = maxItems - 1;
        if (curWeekSelected >= maxItems) curWeekSelected = 0;
    } else if (currentMenuState == 2) {
        curSongSelected += change;
        if (curSongSelected < 0) curSongSelected = maxItems - 1;
        if (curSongSelected >= maxItems) curSongSelected = 0;
    } else if (currentMenuState == 3) {
        curAchievementSelected += change;
        if (curAchievementSelected < 0) curAchievementSelected = maxItems - 1;
        if (curAchievementSelected >= maxItems) curAchievementSelected = 0;
    }

    for (i in 0...itemList.length) {
        var item = itemList[i];
        item.x = (FlxG.width - 500) / 2;
    }
}

function initMenuShader() {
    menuShader = new CustomShader("menutv");
    menuShader.iTime = 0;
    if (bgGlitch != null) {
        bgGlitch.shader = menuShader;
    }
    if (bgBack != null) {
        bgBack.shader = menuShader;
    }
}