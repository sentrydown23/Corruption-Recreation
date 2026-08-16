import flixel.math.FlxRect;
import funkin.backend.assets.Assets;
import openfl.filters.ShaderFilter;
import Xml;

var weekSprites:FlxTypedGroup<FlxSprite>;
var iconGroup:FlxTypedGroup<HealthIcon>;
var blackHeaderBar:FlxSprite;
var blackBottomBar:FlxSprite;
var blackBackgroundBox:FlxSprite;
var txtWeekTitle:FlxText;
var txtTracklist:FlxText;
var rankText:FlxText;

var bgLeft:FlxSprite;
var bfLeft:FlxSprite;
var bfLeftEye:FlxSprite;
var bgRight:FlxSprite;
var bfRight:FlxSprite;

var bgLeftPath:String = "menus/story/bgLeft";
var bfLeftPath:String = "menus/story/bfLeft";
var bfLeftEyePath:String = "menus/story/bfLeftEye";
var bgRightPath:String = "menus/story/bgRight";
var bfRightPath:String = "menus/story/bfRight";

var stupidOffsets:Float = 300;

var bgLeftX:Float = 0;
var bgLeftY:Float = 56 - stupidOffsets;
var bgLeftScaleX:Float = 1.0;
var bgLeftScaleY:Float = 1.0;

var bfLeftX:Float = 0;
var bfLeftY:Float = 56 - stupidOffsets;
var bfLeftScaleX:Float = 1.0;
var bfLeftScaleY:Float = 1.0;

var bgRightX:Float = 640;
var bgRightY:Float = 56 - stupidOffsets;
var bgRightScaleX:Float = 1.0;
var bgRightScaleY:Float = 1.0;

var bfRightX:Float = 0;
var bfRightY:Float = 56 - stupidOffsets;
var bfRightScaleX:Float = 1.0;
var bfRightScaleY:Float = 1.0;

var curWeek:Int = 0;
var selectedWeek:Bool = false;
var canInteract:Bool = true;

var loadedWeekImages:Array<String> = [];
var loadedWeekTitles:Array<String> = [];
var loadedWeekTracks:Array<Array<String>> = [];
var loadedWeekNames:Array<String> = [];

var weekIconsMap:Array<Array<String>> = [
    ["monster-frostbite", "bf-frostbite2"],
    ["pico1", "bf-corrupted"],
    ["spooky", "bf-corrupted"],
    ["mom2", "picofull"],
    ["senpai2", "bf-pixel2"],
    ["dad-lament-1", "bf-corrupted"],
    ["soul", "bf"]
];

var weekIconTypesMap:Array<Array<String>> = [
    ["opponent", "player"],
    ["opponent", "player"],
    ["opponent", "player"],
    ["opponent", "player"],
    ["opponent", "player"],
    ["opponent", "player"],
    ["opponent", "player"]
];

var weekIconOffsetsMap:Array<Array<Array<Float>>> = [ // can i get a tripple array stack weewee deluxe
    [[0, 5], [0, 0]],
    [[0, 0]],
    [[0, 0]],
    [[0, 0]],
    [[0, 0]],
    [[0, 0]]
];

var iconSpacing:Float = 20;
var iconGlobalScale:Float = 0.8;

var abberationShader:CustomShader;
var blurShader:CustomShader;

var abberationAmount:Float = 0.0;
var blurAmount:Float = 0.05;
var blurTween:FlxTween;
var abberationTween:FlxTween;

var menuBPM:Float = 85.0;
var beatTimer:Float = 0.0;
var beatCount:Int = 0;
var standardZoomIntensity:Float = 0.025;
var downbeatZoomIntensity:Float = 0.055;

var enableCameraBopping:Bool = true;

function create() {
    selectedWeek = false;
    canInteract = true;

    FlxG.sound.playMusic(Paths.music("story"), 0.7, true);

    fetchWeeksFromPaths();

    blackBackgroundBox = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFF000000);
    add(blackBackgroundBox);

    bgLeft = new FlxSprite(bgLeftX, bgLeftY);
    if (Paths.image(bgLeftPath) != null) bgLeft.loadGraphic(Paths.image(bgLeftPath));
    bgLeft.scale.set(bgLeftScaleX, bgLeftScaleY);
    bgLeft.updateHitbox();
    add(bgLeft);

    bfLeft = new FlxSprite(bfLeftX, bfLeftY);
    if (Paths.image(bfLeftPath) != null) bfLeft.loadGraphic(Paths.image(bfLeftPath));
    bfLeft.scale.set(bfLeftScaleX, bfLeftScaleY);
    bfLeft.updateHitbox();
    add(bfLeft);

    bfLeftEye = new FlxSprite(bfLeftX, bfLeftY);
    if (Paths.image(bfLeftEyePath) != null) bfLeftEye.loadGraphic(Paths.image(bfLeftEyePath));
    bfLeftEye.scale.set(bfLeftScaleX, bfLeftScaleY);
    bfLeftEye.updateHitbox();
    bfLeftEye.alpha = 0.0;
    add(bfLeftEye);

    bgRight = new FlxSprite(bgRightX, bgRightY);
    if (Paths.image(bgRightPath) != null) bgRight.loadGraphic(Paths.image(bgRightPath));
    bgRight.scale.set(bgRightScaleX, bgRightScaleY);
    bgRight.updateHitbox();
    add(bgRight);

    bfRight = new FlxSprite(bfRightX, bfRightY);
    if (Paths.image(bfRightPath) != null) bfRight.loadGraphic(Paths.image(bfRightPath));
    bfRight.scale.set(bfRightScaleX, bfRightScaleY);
    bfRight.updateHitbox();
    add(bfRight);

    var bottomBarY:Float = blackBackgroundBox.y + blackBackgroundBox.height;
    var bottomBarHeight:Int = Std.int(FlxG.height - bottomBarY);
    blackBottomBar = new FlxSprite(0, bottomBarY).makeGraphic(FlxG.width, bottomBarHeight, 0xFF050505);
    add(blackBottomBar);

    weekSprites = new FlxTypedGroup<FlxSprite>();
    add(weekSprites);

    iconGroup = new FlxTypedGroup<HealthIcon>();
    add(iconGroup);

    blackHeaderBar = new FlxSprite(0, 0).makeGraphic(FlxG.width, 56, 0xFF050505);
    add(blackHeaderBar);

    txtWeekTitle = new FlxText(0, 0, FlxG.width, "", 32);
    txtWeekTitle.setFormat(Paths.font("Cardamon Regular.ttf"), 32, FlxColor.WHITE, "center");
    txtWeekTitle.y = (blackHeaderBar.height / 2) - (txtWeekTitle.height / 2);
    txtWeekTitle.alpha = 0.7;
    add(txtWeekTitle);

    rankText = new FlxText(FlxG.width * 0.05, blackBottomBar.y + 15, 0, "TRACKS", 32);
    rankText.setFormat(Paths.font("Cardamon Regular.ttf"), 32, 0xFFb00028, "left");
    add(rankText);

    txtTracklist = new FlxText(FlxG.width * 0.05, rankText.y + 40, 0, "", 32);
    txtTracklist.setFormat(Paths.font("Cardamon Regular.ttf"), 32, 0xFFE55777, "left");
    add(txtTracklist);

    applyCustomShaders();

    buildWeekSprites();
    changeWeek(0);
}

function applyCustomShaders() {
    try {
        abberationShader = new CustomShader("menuabberation");
        abberationShader.amount = abberationAmount;

        blurShader = new CustomShader("blur");
        blurShader.uBlur = blurAmount;

        FlxG.camera.setFilters([
            new ShaderFilter(abberationShader),
            new ShaderFilter(blurShader)
        ]);

        blurTween = FlxTween.num(0.05, 0.01, 2.0, {
            type: FlxTween.PINGPONG,
            ease: FlxEase.sineInOut,
            onUpdate: function(t:FlxTween) {
                blurAmount = t.value;
            }
        });
    } catch(e:Dynamic) {}
}

function fetchWeeksFromPaths() {
    loadedWeekImages = [];
    loadedWeekTitles = [];
    loadedWeekTracks = [];
    loadedWeekNames = [];

    var txtContent:String = "";
    var weeksPath:String = Paths.file("data/weeks/weeks.txt");

    if (Assets.exists(weeksPath)) {
        txtContent = Assets.getText(weeksPath);
    } else if (Assets.exists("data/weeks/weeks.txt")) {
        txtContent = Assets.getText("data/weeks/weeks.txt");
    }

    if (txtContent == null || txtContent == "") {
        return;
    }

    var rawLines:Array<String> = txtContent.split("\n");

    for (line in rawLines) {
        var weekName:String = StringTools.trim(line);
        if (weekName == "" || StringTools.startsWith(weekName, "#")) continue;

        var xmlAssetPath:String = Paths.file("data/weeks/weeks/" + weekName + ".xml");
        var xmlRaw:String = "";

        if (Assets.exists(xmlAssetPath)) {
            xmlRaw = Assets.getText(xmlAssetPath);
        } else if (Assets.exists("data/weeks/weeks/" + weekName + ".xml")) {
            xmlRaw = Assets.getText("data/weeks/weeks/" + weekName + ".xml");
        }

        if (xmlRaw != null && xmlRaw != "") {
            try {
                var parsedXml:Xml = Xml.parse(xmlRaw);
                var root:Xml = parsedXml.firstElement();

                if (root != null) {
                    if (root.get("hideInStoryMode") == "true" || root.get("hideStory") == "true") {
                        continue;
                    }

                    var sprName:String = root.exists("sprite") ? root.get("sprite") : (root.exists("name") ? root.get("name") : weekName);
                    var wTitle:String = root.exists("title") ? root.get("title") : (root.exists("name") ? root.get("name") : sprName);

                    loadedWeekNames.push(weekName);
                    loadedWeekImages.push(sprName);
                    loadedWeekTitles.push(wTitle.toUpperCase());

                    var songList:Array<String> = [];
                    for (node in root.elements()) {
                        if (node.nodeName == "song") {
                            var songName:String = "";
                            if (node.firstChild() != null && node.firstChild().nodeValue != null) {
                                songName = StringTools.trim(node.firstChild().nodeValue);
                            }
                            if (songName == "" && node.exists("name")) {
                                songName = node.get("name");
                            }
                            if (songName != "") {
                                songList.push(songName);
                            }
                        }
                    }

                    loadedWeekTracks.push(songList);
                }
            } catch(e:Dynamic) {}
        }
    }
}

function buildWeekSprites() {
    var centerY:Float = blackBottomBar.y + (blackBottomBar.height / 2) - 30;

    for (i in 0...loadedWeekImages.length) {
        var imgPath:String = "menus/story/" + loadedWeekImages[i];
        var imgGraphic = Paths.image(imgPath);

        var startY:Float = centerY + ((i - curWeek) * 80);
        var item:FlxSprite = new FlxSprite(0, startY);

        if (imgGraphic != null) {
            item.loadGraphic(imgGraphic);
        }

        var targetScale:Float = 0.6;
        if (loadedWeekImages[i] == "storyfrost" || loadedWeekImages[i] == "frost") {
            targetScale = 0.3;
        }

        if (item.graphic != null && item.graphic.width > 500) {
            var ratio:Float = 350.0 / item.graphic.width;
            if (ratio < targetScale) {
                targetScale = ratio;
            }
        }

        item.scale.set(targetScale, targetScale);
        item.updateHitbox();
        item.screenCenter(0x01);

        weekSprites.add(item);
    }
}

function updateIcons() {
    iconGroup.clear();

    if (curWeek >= 0 && curWeek < weekIconsMap.length) {
        var currentIcons:Array<String> = weekIconsMap[curWeek];
        var currentTypes:Array<String> = (curWeek < weekIconTypesMap.length) ? weekIconTypesMap[curWeek] : [];
        var currentOffsets:Array<Array<Float>> = (curWeek < weekIconOffsetsMap.length) ? weekIconOffsetsMap[curWeek] : [];
        var totalIcons:Int = currentIcons.length;

        var baseRightX:Float = FlxG.width - 50;

        for (i in 0...totalIcons) {
            var iconName:String = currentIcons[i];
            var iconType:String = (i < currentTypes.length) ? currentTypes[i] : "opponent";
            var iconOffset:Array<Float> = (i < currentOffsets.length) ? currentOffsets[i] : [0, 0];
            
            var icon:HealthIcon = new HealthIcon(iconName, false);
            icon.sprTracker = null;
            icon.scale.set(iconGlobalScale, iconGlobalScale);
            icon.updateHitbox();

            var baseY:Float = blackBottomBar.y + (blackBottomBar.height / 2) - (icon.height / 2);
            var scaledWidth:Float = icon.width;

            switch (iconType) {
                case "player":
                    icon.x = baseRightX - scaledWidth;
                    icon.y = baseY;
                    icon.flipX = true;

                case "player-flip":
                    icon.x = baseRightX - scaledWidth;
                    icon.y = baseY;
                    icon.flipX = false;

                case "opponent":
                    var groupWidth:Float = (totalIcons * scaledWidth) + ((totalIcons - 1) * iconSpacing);
                    icon.x = (baseRightX - groupWidth) + (i * (scaledWidth + iconSpacing));
                    icon.y = baseY;
                    icon.flipX = false;

                case "middle":
                    var playerX:Float = baseRightX - scaledWidth;
                    var groupWidth:Float = (totalIcons * scaledWidth) + ((totalIcons - 1) * iconSpacing);
                    var opponentX:Float = baseRightX - groupWidth;
                    icon.x = (playerX + opponentX) / 2;
                    icon.y = baseY - 15;
                    icon.flipX = false;

                case "middle-flip":
                    var playerX:Float = baseRightX - scaledWidth;
                    var groupWidth:Float = (totalIcons * scaledWidth) + ((totalIcons - 1) * iconSpacing);
                    var opponentX:Float = baseRightX - groupWidth;
                    icon.x = (playerX + opponentX) / 2;
                    icon.y = baseY - 15;
                    icon.flipX = true;

                default:
                    var groupWidth:Float = (totalIcons * scaledWidth) + ((totalIcons - 1) * iconSpacing);
                    icon.x = (baseRightX - groupWidth) + (i * (scaledWidth + iconSpacing));
                    icon.y = baseY;
                    icon.flipX = false;
            }

            icon.x += iconOffset[0];
            icon.y += iconOffset[1];

            iconGroup.add(icon);
        }
    }
}

function update(elapsed:Float) {
    var minClipY:Float = blackBottomBar.y;
    var maxClipY:Float = FlxG.height;
    var centerY:Float = blackBottomBar.y + (blackBottomBar.height / 2) - 30;

    if (abberationShader != null) {
        abberationShader.amount = abberationAmount;
    }
    if (blurShader != null) {
        blurShader.uBlur = blurAmount;
    }

    if (enableCameraBopping && FlxG.sound.music != null && FlxG.sound.music.playing) {
        var totalBeats:Int = Math.floor((FlxG.sound.music.time / 1000) * (menuBPM / 60.0));
        
        if (totalBeats > beatCount) {
            beatCount = totalBeats;
            
            if (beatCount % 4 == 0) {
                bfLeft.scale.set(bfLeftScaleX + 0.08, bfLeftScaleY + 0.04);
                bfRight.scale.set(bfRightScaleX + 0.08, bfRightScaleY + 0.04);
            } else {
                bfLeft.scale.set(bfLeftScaleX + 0.02, bfLeftScaleY + 0.02);
                bfRight.scale.set(bfRightScaleX + 0.02, bfRightScaleY + 0.02);
            }
        }
    }
    
    bfLeft.scale.x = FlxMath.lerp(bfLeft.scale.x, bfLeftScaleX, FlxMath.bound(elapsed * 3.125, 0, 1));
    bfLeft.scale.y = FlxMath.lerp(bfLeft.scale.y, bfLeftScaleY, FlxMath.bound(elapsed * 3.125, 0, 1));
    
    bfLeftEye.scale.x = FlxMath.lerp(bfLeftEye.scale.x, bfLeftScaleX, FlxMath.bound(elapsed * 3.125, 0, 1));
    bfLeftEye.scale.y = FlxMath.lerp(bfLeftEye.scale.y, bfLeftScaleY, FlxMath.bound(elapsed * 3.125, 0, 1));
    
    bfRight.scale.x = FlxMath.lerp(bfRight.scale.x, bfRightScaleX, FlxMath.bound(elapsed * 3.125, 0, 1));
    bfRight.scale.y = FlxMath.lerp(bfRight.scale.y, bfRightScaleY, FlxMath.bound(elapsed * 3.125, 0, 1));

    for (i in 0...weekSprites.members.length) {
        var item = weekSprites.members[i];
        if (item == null) continue;

        var targetY:Float = centerY + ((i - curWeek) * 80);
        item.y = FlxMath.lerp(item.y, targetY, FlxMath.bound(elapsed * 10.2, 0, 1));

        var clipTop:Float = 0;
        var clipBottom:Float = item.frameHeight;

        if (item.y < minClipY) {
            clipTop = (minClipY - item.y) / item.scale.y;
        }

        if (item.y + item.height > maxClipY) {
            clipBottom = (maxClipY - item.y) / item.scale.y;
        }

        if (clipTop >= clipBottom || item.y > maxClipY || item.y + item.height < minClipY) {
            item.visible = false;
            item.clipRect = null;
        } else {
            item.visible = true;
            item.clipRect = FlxRect.get(0, clipTop, item.frameWidth, clipBottom - clipTop);
        }

        if (!selectedWeek) {
            if (i == curWeek) {
                item.alpha = 1.0;
            } else {
                item.alpha = 0.5;
            }
        }
    }

    if (!selectedWeek && canInteract) {
        var upPressed:Bool = FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W;
        var downPressed:Bool = FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S;
        var acceptPressed:Bool = FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE;
        var backPressed:Bool = FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE;

        if (upPressed) {
            changeWeek(-1);
        }
        if (downPressed) {
            changeWeek(1);
        }
        if (acceptPressed) {
            selectWeek();
        }
        if (backPressed) {
            canInteract = false;
            FlxG.sound.play(Paths.sound("menus/cancel"), 1.0, false, null, true, function() {
                FlxG.switchState(new ModState("MainMenuStateC"));
            });
        }
    }
}

function changeWeek(change:Int) {
    if (loadedWeekImages.length == 0) return;

    curWeek += change;

    if (curWeek < 0) {
        curWeek = loadedWeekImages.length - 1;
    }
    if (curWeek >= loadedWeekImages.length) {
        curWeek = 0;
    }

    if (change != 0) {
        FlxG.sound.play(Paths.sound("menus/scroll"));
    }

    if (curWeek < loadedWeekTitles.length) {
        txtWeekTitle.text = loadedWeekTitles[curWeek];
        txtWeekTitle.screenCenter(0x01);
    }

    if (curWeek < loadedWeekTracks.length) {
        var stringThing:String = "";
        for (track in loadedWeekTracks[curWeek]) {
            stringThing += track + "\n";
        }
        txtTracklist.text = stringThing.toUpperCase();
        txtTracklist.x = FlxG.width * 0.05;
    }

    updateIcons();
}

function selectWeek() {
    if (loadedWeekTracks.length == 0 || curWeek >= loadedWeekTracks.length) return;
    enableCameraBopping = false;

    var trackList:Array<String> = loadedWeekTracks[curWeek];
    if (trackList.length == 0) return;

    selectedWeek = true;
    canInteract = false;

    var selectedDiff:String = "hard";
    var currentWeekID:String = loadedWeekNames[curWeek];
    var firstSong:String = trackList[0].toLowerCase();

    FlxG.sound.play(Paths.sound("menus/weekSelect"));

    var selectedSprite = weekSprites.members[curWeek];
    if (selectedSprite != null) {
        selectedSprite.color = 0xFF33FFFF;
    }

    FlxTween.tween(bfLeftEye, {alpha: 1.0}, 0.2, {ease: FlxEase.quadOut});
    FlxG.sound.music.volume = 0;

    FlxTween.tween(bgLeft, {alpha: 0.0}, 0.001);
    FlxTween.tween(bfLeft, {alpha: 0.0}, 0.001);
    FlxTween.tween(bgRight, {alpha: 0.0}, 0.001);
    FlxTween.tween(bfRight, {alpha: 0.0}, 0.001);
    FlxTween.tween(blackBottomBar, {alpha: 0.0}, 0.001);
    FlxTween.tween(blackHeaderBar, {alpha: 0.0}, 0.001);
    FlxTween.tween(txtWeekTitle, {alpha: 0.0}, 0.001);
    FlxTween.tween(rankText, {alpha: 0.0}, 0.001);
    FlxTween.tween(txtTracklist, {alpha: 0.0}, 0.001);

    for (item in weekSprites.members) {
        if (item != null) {
            FlxTween.tween(item, {alpha: 0.0}, 0.1);
        }
    }

    for (icon in iconGroup.members) {
        if (icon != null) {
            FlxTween.tween(icon, {alpha: 0.0}, 0.1);
        }
    }

    FlxTween.tween(blackBackgroundBox, {alpha: 0.0}, 1.9, {
        onComplete: function(_) {
            FlxTween.tween(bfLeftEye, {alpha: 0.0}, 0.5, {
                onComplete: function(_) {
                    FlxG.switchState(new PlayState());
                }
            });
        }
    });

    PlayState.loadSong(firstSong, selectedDiff);

    PlayState.isStoryMode = true;
    PlayState.storyPlaylist = trackList.copy();
    PlayState.storyWeek = currentWeekID;
    PlayState.storyDifficulty = selectedDiff;

    if (Reflect.hasField(PlayState, "storyWeekFile")) {
        try {
            var weekXmlPath:String = "data/weeks/weeks/" + currentWeekID + ".xml";
            if (Assets.exists(weekXmlPath)) {
                var rawXml:String = Assets.getText(weekXmlPath);
                var parsed:Xml = Xml.parse(rawXml);
                Reflect.setProperty(PlayState, "storyWeekFile", parsed.firstElement());
            }
        } catch(e:Dynamic) {}
    }
}