import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import openfl.filters.ShaderFilter;
import funkin.options.OptionsMenu;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import funkin.menus.FreeplayState.FreeplaySonglist;
import funkin.game.PlayState;
import flixel.text.FlxText;
import flixel.math.FlxMath;


var songListPos:Dynamic = {
    x: 100,
    y: 360,
    spacing: 150,
    lerpSpeed: 0.3,
    size: 44
};

var songs:Array<FreeplaySongMetadata> = [];
var grpSongs:FlxTypedGroup<FlxText>;
var curFreeplaySelected:Int = 0;

var titleLogo:FlxSprite;
var titleMenuItems:FlxTypedGroup<FlxSprite>;

var titleMusic:FlxSound;
var freeplayMusic:FlxSound;

var burn:FlxSprite;

var layer1:FlxSprite;
var layer2:FlxSprite;
var layer3:FlxSprite;
var layer4:FlxSprite;
var layer5:FlxSprite;
var layer6:FlxSprite;
var floatingBF:FlxSprite;
var lightRays:FlxSprite;

var layer1TargetX:Float = 0;
var layer1TargetY:Float = 0;
var layer2TargetX:Float = 0;
var layer2TargetY:Float = 0;
var layer3TargetX:Float = 0;
var layer3TargetY:Float = 0;
var layer4TargetX:Float = 0;
var layer4TargetY:Float = 0;
var layer5TargetX:Float = 0;
var layer5TargetY:Float = 0;
var bfTargetY:Float = 0;

var menuButtons:Array<FlxSprite> = [];
var menuButtonsSelected:Array<FlxSprite> = [];
var selectionBeams:Array<FlxSprite> = [];
var buttonTargetXs:Array<Float> = [];
var buttonTargetYs:Array<Float> = [];

var audioConfig:Dynamic = {
    titleToMenuOutDuration: 0.8,
    titleToMenuOutDelay: 0.8,
    
    titleToMenuInDuration: 0.8,
    titleToMenuInDelay: 0.7,
    titleToMenuTargetVolume: 0.7,

    menuToFreeplayOutDuration: 0.6,
    menuToFreeplayOutDelay: 0.5,

    freeplayInDuration: 0.8,
    freeplayInDelay: 0.4,
    freeplayTargetVolume: 1.0,

    freeplayOutDuration: 0.8,
    freeplayOutDelay: 0.25,

    freeplayToMenuInDuration: 0.5,
    freeplayToMenuInDelay: 0.25,
    freeplayToMenuTargetVolume: 0.7
};

var curSelected:Int = 0;
var canInteract:Bool = false;
var inMainMenu:Bool = false;

var blurShader:CustomShader;
var waveShader:CustomShader;
var chromaticShader:CustomShader;

function create() {
    if (FlxG.sound.music != null && FlxG.sound.music.playing) {
        FlxG.sound.music.stop();
        FlxG.sound.music = null;
    }

    if (titleMusic != null && titleMusic.playing) {
        titleMusic.stop();
        titleMusic.destroy();
        titleMusic = null;
    }

    if (!hasSeenTitle) {
        titleMusic = FlxG.sound.play(Paths.music("title"), 0.6, true);
        FlxG.sound.playMusic(Paths.music("mainmenu"), 0.0, true);
    } else {
        FlxG.sound.playMusic(Paths.music("mainmenu"), 0.7, true);
    }
}

function postCreate()
{
    blurShader = new CustomShader("blur2");
    waveShader = new CustomShader("waves");
    chromaticShader = new CustomShader("menuabberation");

    blurShader.strength = 0.0;
    blurShader.angle = 90;
    waveShader.iTime = 0;
    
    chromaticShader.amount = 0.5;

    FlxG.camera.setFilters([
        new ShaderFilter(blurShader),
        new ShaderFilter(waveShader),
        new ShaderFilter(chromaticShader)
    ]);

    buildMainMenuSprites();
    buildFreeplaySprites();
    buildFreeplaySongList();
    buildBurnSprite();

    if (hasSeenTitle) {
        showMainMenuDirectly();
    } else {
        hasSeenTitle = true;

        titleLogo = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/title/titlelogo"));
        titleLogo.scale.set(0.24, 0.24);
        titleLogo.updateHitbox();
        titleLogo.antialiasing = true;
        
        titleLogo.screenCenter();
        titleLogo.x = ((FlxG.width * 0.25) - (titleLogo.width / 2)) - 20;
        add(titleLogo);

        titleMenuItems = new FlxTypedGroup<FlxSprite>();
        add(titleMenuItems);

        var rightAreaCenterX:Float = (FlxG.width * 0.75) - 50;

        for (i in 0...7) {
            var item:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/title/title" + i));
            item.scale.set(0.6, 0.6);
            item.updateHitbox();
            item.antialiasing = true;

            item.screenCenter();
            item.x = rightAreaCenterX - (item.width / 2);
            item.y += -50;

            titleMenuItems.add(item);
        }

        canInteract = true;
    }
}

function buildBurnSprite() {
    burn = new FlxSprite(0, 0);
    burn.frames = Paths.getSparrowAtlas("menus/mainmenu/burn");
    burn.animation.addByPrefix("burnTransition", "burnTransition", 12, false);
    burn.antialiasing = true;
    burn.scrollFactor.set(0, 0);
    burn.setGraphicSize(FlxG.width, FlxG.height);
    burn.updateHitbox();
    burn.visible = false;
    add(burn);
}

function triggerBurnTransition(onFinishCallback:Void->Void) {
    canInteract = false;
    FlxG.sound.music.volume = 0;

    burn.visible = true;
    burn.animation.play("burnTransition");
    
    var burnSound = FlxG.sound.play(Paths.sound("menus/burn"));
    if (burnSound != null) {
        burnSound.onComplete = function() {
            burn.visible = false;
            FlxG.camera.visible = false;
            
            if (onFinishCallback != null) {
                onFinishCallback();
            }
        };
    } else {
        burn.animation.finishCallback = function(name:String) {
            if (name == "burnTransition") {
                burn.visible = false;
                FlxG.camera.visible = false;
                
                if (onFinishCallback != null) {
                    onFinishCallback();
                }
            }
        };
    }
}

function update(elapsed:Float) {
    if (waveShader != null) {
        waveShader.iTime += elapsed;
    }

    if (inFreeplay) {
        updateFreeplaySongList(elapsed);
    }

    if (canInteract) {
        if (!inMainMenu && !inFreeplay && FlxG.keys.justPressed.ENTER) {
            transitionToMainMenu();
        } else if (inMainMenu) {
            if (FlxG.keys.justPressed.UP) {
                changeSelection(-1);
            } else if (FlxG.keys.justPressed.DOWN) {
                changeSelection(1);
            } else if (FlxG.keys.justPressed.ENTER) {
                selectButton();
            } else if(FlxG.keys.justPressed.TAB) {
                openSubState(new ModSwitchMenu());
            } else if(FlxG.keys.justPressed.SEVEN || FlxG.keys.justPressed.SIX) {
                openSubState(new EditorPicker());
            }
        } else if (inFreeplay) {
            if (FlxG.keys.justPressed.UP) {
                changeFreeplaySelection(-1);
            } else if (FlxG.keys.justPressed.DOWN) {
                changeFreeplaySelection(1);
            } else if (FlxG.keys.justPressed.ENTER) {
                selectFreeplaySong();
            } else if (FlxG.keys.justPressed.BACKSPACE) {
                exitFreeplay();
            }
        }
    }
}

function selectButton() {
    FlxG.sound.play(Paths.sound("menus/confirm"));

    switch (curSelected) {
        case 0:
            canInteract = false;
            triggerBurnTransition(function() {
                FlxG.switchState(new StoryMenuState());
            });
        case 1:
            canInteract = false;
            openFreeplay();
        case 2:
            canInteract = false;
            exitToState(function() {
                FlxG.switchState(new OptionsMenu());
            }, "right");
        case 3: 
            canInteract = false;
            exitToState(function() {
                FlxG.switchState(new ModState("ExtrasMenuState"));
            }, "up");
        case 4: return;
    }
}

function exitToState(onCompleteCallback:Void->Void, direction:String) {
    var xMod:Float = 0;
    var yMod:Float = 0;

    switch (direction) {
        case "up":
            yMod = -FlxG.height * 1.2;
        case "down":
            yMod = FlxG.height * 1.2;
        case "left":
            xMod = -FlxG.width * 1.2;
        case "right":
            xMod = FlxG.width * 1.2;
    }

    var dur:Float = 1.0;
    var easeType = FlxEase.expoIn;

    FlxTween.tween(lightRays, {alpha: 0}, dur * 0.8);
    FlxTween.tween(layer1, {x: layer1.x + xMod, y: layer1.y + yMod, alpha: 0}, dur, {ease: easeType});
    FlxTween.tween(layer2, {x: layer2.x + xMod, y: layer2.y + yMod, alpha: 0}, dur, {ease: easeType});
    FlxTween.tween(layer3, {x: layer3.x + xMod, y: layer3.y + yMod, alpha: 0}, dur, {ease: easeType});
    FlxTween.tween(layer4, {x: layer4.x + xMod, y: layer4.y + yMod, alpha: 0}, dur, {ease: easeType});
    FlxTween.tween(layer5, {x: layer5.x + xMod, y: layer5.y + yMod, alpha: 0}, dur, {ease: easeType});
    FlxTween.tween(floatingBF, {x: floatingBF.x + xMod, y: floatingBF.y + yMod, alpha: 0}, dur, {ease: easeType});

    var totalButtons:Int = menuButtons.length;
    var completedButtons:Int = 0;

    for (i in 0...totalButtons) {
        var delayTime:Float = 0.05 * i;

        FlxTween.tween(menuButtons[i], {x: menuButtons[i].x + xMod, y: menuButtons[i].y + yMod, alpha: 0}, dur, {
            ease: easeType,
            startDelay: delayTime
        });
        FlxTween.tween(menuButtonsSelected[i], {x: menuButtonsSelected[i].x + xMod, y: menuButtonsSelected[i].y + yMod, alpha: 0}, dur, {
            ease: easeType,
            startDelay: delayTime
        });
        FlxTween.tween(selectionBeams[i], {x: selectionBeams[i].x + xMod, y: selectionBeams[i].y + yMod, alpha: 0}, dur, {
            ease: easeType,
            startDelay: delayTime,
            onComplete: function(_) {
                completedButtons++;
                if (completedButtons >= totalButtons) {
                    if (onCompleteCallback != null) {
                        onCompleteCallback();
                    }
                }
            }
        });
    }
}

function changeSelection(change:Int = 0) {
    if (change != 0) {
        FlxG.sound.play(Paths.sound("menus/scroll"));
    }

    curSelected += change;

    if (curSelected < 0) {
        curSelected = menuButtons.length - 1;
    } else if (curSelected >= menuButtons.length) {
        curSelected = 0;
    }

    for (i in 0...menuButtons.length) {
        var isSelected:Bool = (i == curSelected);

        menuButtons[i].visible = !isSelected;
        menuButtonsSelected[i].visible = isSelected;
        selectionBeams[i].visible = isSelected;
    }
}

function buildMainMenuSprites() {
    var offscreenOffset:Float = FlxG.height * 1.5;

    layer1 = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/mainmenu/layer1"));
    layer1.scale.set(0.7, 0.7);
    layer1.updateHitbox();
    layer1.antialiasing = true;
    layer1.screenCenter();
    layer1TargetX = layer1.x + 500;
    layer1TargetY = layer1.y - 50;
    layer1.x = layer1TargetX;
    layer1.y = layer1TargetY + offscreenOffset;
    layer1.alpha = 0;
    add(layer1);

    layer2 = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/mainmenu/layer2"));
    layer2.scale.set(0.7, 0.7);
    layer2.updateHitbox();
    layer2.antialiasing = true;
    layer2.screenCenter();
    layer2TargetX = layer2.x + 550;
    layer2TargetY = layer2.y + 350;
    layer2.x = layer2TargetX;
    layer2.y = layer2TargetY + offscreenOffset;
    layer2.alpha = 0;
    add(layer2);

    layer3 = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/mainmenu/layer3"));
    layer3.scale.set(1.0, 1.0);
    layer3.updateHitbox();
    layer3.antialiasing = true;
    layer3.screenCenter();
    layer3TargetX = layer3.x + 250;
    layer3TargetY = layer3.y + 250;
    layer3.x = layer3TargetX;
    layer3.y = layer3TargetY + offscreenOffset;
    layer3.alpha = 0;
    add(layer3);

    layer4 = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/mainmenu/layer4"));
    layer4.scale.set(0.9, 0.9);
    layer4.updateHitbox();
    layer4.antialiasing = true;
    layer4.screenCenter();
    layer4TargetX = layer4.x - 350;
    layer4TargetY = layer4.y;
    layer4.x = layer4TargetX;
    layer4.y = layer4TargetY + offscreenOffset;
    layer4.alpha = 0;
    add(layer4);

    layer5 = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/mainmenu/layer5"));
    layer5.scale.set(1.0, 1.0);
    layer5.updateHitbox();
    layer5.antialiasing = true;
    layer5.screenCenter();
    layer5TargetX = layer5.x + 880;
    layer5TargetY = layer5.y - 10;
    layer5.x = layer5TargetX;
    layer5.y = layer5TargetY + offscreenOffset;
    layer5.alpha = 0;
    add(layer5);

    layer6 = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/mainmenu/layer6"));
    layer6.scale.set(1.0, 1.0);
    layer6.updateHitbox();
    layer6.antialiasing = true;
    layer6.screenCenter();
    layer6.visible = false;
    add(layer6);

    floatingBF = new FlxSprite(0, 0);
    floatingBF.frames = Paths.getSparrowAtlas("menus/mainmenu/floatingBF");
    floatingBF.animation.addByPrefix("BfFloat", "BfFloat", 24, true);
    floatingBF.animation.play("BfFloat");
    floatingBF.scale.set(0.65, 0.65);
    floatingBF.updateHitbox();
    floatingBF.antialiasing = true;
    floatingBF.screenCenter();
    bfTargetY = floatingBF.y - 50;
    floatingBF.y = bfTargetY + offscreenOffset;
    floatingBF.alpha = 0;
    add(floatingBF);

    lightRays = new FlxSprite(0, 0);
    lightRays.frames = Paths.getSparrowAtlas("menus/mainmenu/lightRays");
    lightRays.animation.addByPrefix("LightRays", "LightRays", 10, true);
    lightRays.animation.play("LightRays");
    lightRays.scale.set(0.7, 0.7);
    lightRays.updateHitbox();
    lightRays.antialiasing = true;
    lightRays.screenCenter();
    lightRays.y -= 200;
    lightRays.alpha = 0;
    add(lightRays);

    var startY:Float = (FlxG.height / 2) - 50;

    var buttonScales:Array<Float> = [0.5, 0.5, 0.5, 0.5, 0.5];
    var buttonSelectedScales:Array<Float> = [0.53, 0.53, 0.53, 0.53, 0.53];
    var buttonXOffsets:Array<Float> = [0, 0, 0, 0, 0];
    var buttonYOffsets:Array<Float> = [0, 0, 0, 0, 0];
    var buttonSelectedXOffsets:Array<Float> = [0, 0, 0, 0, 0];
    var buttonSelectedYOffsets:Array<Float> = [-20, -20, -20, -20, -20];

    var beamScaleOffsets:Array<Float> = [0.02, 0.02, 0.02, 0.02, 0.02];
    var beamXOffsets:Array<Float> = [0, 0, 0, 0, 0];
    var beamYOffsets:Array<Float> = [-5, -10, -15, -20, -25];
    var beamAlphas:Array<Float> = [0.2, 0.2, 0.2, 0.2, 0.2];

    for (i in 0...5) {
        var unselectedScale:Float = buttonScales[i];
        var selectedScale:Float = buttonSelectedScales[i];
        var calculatedBeamScale:Float = selectedScale + beamScaleOffsets[i];

        var beam:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/mainmenu/b" + i));
        beam.scale.set(calculatedBeamScale, calculatedBeamScale);
        beam.updateHitbox();
        beam.antialiasing = true;
        beam.screenCenter();
        beam.alpha = beamAlphas[i];
        
        var baseTargetX:Float = beam.x + 500 + buttonSelectedXOffsets[i] + beamXOffsets[i];
        var baseTargetY:Float = startY + (i * 20) - 350 + buttonSelectedYOffsets[i] + beamYOffsets[i];
        
        buttonTargetXs.push(baseTargetX);
        buttonTargetYs.push(baseTargetY);

        beam.x = baseTargetX;
        beam.y = baseTargetY + offscreenOffset;
        add(beam);
        selectionBeams.push(beam);

        var btnUnselected:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/mainmenu/t" + i));
        btnUnselected.scale.set(unselectedScale, unselectedScale);
        btnUnselected.updateHitbox();
        btnUnselected.antialiasing = true;
        btnUnselected.screenCenter();
        btnUnselected.alpha = 0.3;
        btnUnselected.x = btnUnselected.x + 500 + buttonXOffsets[i];
        btnUnselected.y = startY + (i * 20) - 350 + buttonYOffsets[i] + offscreenOffset;
        add(btnUnselected);
        menuButtons.push(btnUnselected);

        var btnSelected:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/mainmenu/s" + i));
        btnSelected.scale.set(selectedScale, selectedScale);
        btnSelected.updateHitbox();
        btnSelected.antialiasing = true;
        btnSelected.screenCenter();
        btnSelected.x = btnSelected.x + 500 + buttonSelectedXOffsets[i];
        btnSelected.y = startY + (i * 20) - 350 + buttonSelectedYOffsets[i] + offscreenOffset;
        add(btnSelected);
        menuButtonsSelected.push(btnSelected);
    }

    changeSelection(0);
}

function transitionToMainMenu() {
    canInteract = false;
    FlxG.sound.play(Paths.sound("menus/confirm"));
    FlxG.camera.flash(0xFFFFFFFF, 0.35);

    if (titleMusic != null) {
        FlxTween.num(titleMusic.volume, 0, audioConfig.titleToMenuOutDuration, {
            startDelay: audioConfig.titleToMenuOutDelay,
            onUpdate: function(t:FlxTween) {
                if (titleMusic != null) titleMusic.volume = t.value;
            },
            onComplete: function(_) {
                if (titleMusic != null) {
                    titleMusic.stop();
                    titleMusic.destroy();
                    titleMusic = null;
                }
            }
        });
    }

    if (FlxG.sound.music != null) {
        FlxG.sound.music.volume = 0;
        FlxTween.num(0, audioConfig.titleToMenuTargetVolume, audioConfig.titleToMenuInDuration, {
            startDelay: audioConfig.titleToMenuInDelay,
            onUpdate: function(t:FlxTween) {
                if (FlxG.sound.music != null) FlxG.sound.music.volume = t.value;
            }
        });
    }

    FlxTween.tween(titleLogo, {y: titleLogo.y + 40.0}, 0.35, {
        ease: FlxEase.quadInOut,
        onComplete: function(_) {
            FlxTween.tween(titleLogo, {
                y: titleLogo.y - (FlxG.height * 1.5),
                alpha: 0
            }, 0.8, {
                ease: FlxEase.expoIn
            });
        }
    });

    for (item in titleMenuItems.members) {
        FlxTween.tween(item, {y: item.y + 40.0}, 0.35, {
            ease: FlxEase.quadInOut,
            onComplete: function(_) {
                FlxTween.tween(item, {
                    y: item.y - (FlxG.height * 1.5),
                    alpha: 0
                }, 0.8, {
                    ease: FlxEase.expoIn
                });
            }
        });
    }

    FlxTween.tween(lightRays, {alpha: 1}, 1.4, {
        ease: FlxEase.quadOut,
        startDelay: 1.1
    });

    var layers:Array<Dynamic> = [
        {sprite: layer1, targetY: layer1TargetY},
        {sprite: layer2, targetY: layer2TargetY},
        {sprite: layer3, targetY: layer3TargetY},
        {sprite: layer4, targetY: layer4TargetY},
        {sprite: layer5, targetY: layer5TargetY},
        {sprite: floatingBF, targetY: bfTargetY}
    ];

    for (layerData in layers) {
        var spr:FlxSprite = layerData.sprite;
        var finalY:Float = layerData.targetY;

        FlxTween.tween(spr, {y: finalY, alpha: 1}, 1.4, {
            ease: FlxEase.expoOut,
            startDelay: 1.1
        });
    }

    var totalButtons:Int = menuButtons.length;
    var completedButtons:Int = 0;

    for (i in 0...totalButtons) {
        var targetY:Float = buttonTargetYs[i];
        var unselectedTargetY:Float = targetY + (menuButtons[i].y - selectionBeams[i].y);
        var selectedTargetY:Float = targetY + (menuButtonsSelected[i].y - selectionBeams[i].y);

        FlxTween.tween(menuButtons[i], {y: unselectedTargetY}, 1.4, {
            ease: FlxEase.expoOut,
            startDelay: 1.1 + (0.1 * i)
        });

        FlxTween.tween(menuButtonsSelected[i], {y: selectedTargetY}, 1.4, {
            ease: FlxEase.expoOut,
            startDelay: 1.1 + (0.1 * i)
        });

        FlxTween.tween(selectionBeams[i], {y: targetY}, 1.4, {
            ease: FlxEase.expoOut,
            startDelay: 1.1 + (0.1 * i),
            onComplete: function(_) {
                completedButtons++;
                if (completedButtons >= totalButtons) {
                    cleanupTitleAndEnableMenu();
                }
            }
        });
    }
}

function cleanupTitleAndEnableMenu() {
    inMainMenu = true;
    canInteract = true;

    if (titleLogo != null) {
        titleLogo.destroy();
        titleLogo = null;
    }
    if (titleMenuItems != null) {
        titleMenuItems.destroy();
        titleMenuItems = null;
    }
}

function showMainMenuDirectly() {
    inMainMenu = true;
    canInteract = true;

    lightRays.alpha = 1;

    layer1.y = layer1TargetY;
    layer1.alpha = 1;

    layer2.y = layer2TargetY;
    layer2.alpha = 1;

    layer3.y = layer3TargetY;
    layer3.alpha = 1;

    layer4.y = layer4TargetY;
    layer4.alpha = 1;

    layer5.y = layer5TargetY;
    layer5.alpha = 1;

    floatingBF.y = bfTargetY;
    floatingBF.alpha = 1;

    for (i in 0...menuButtons.length) {
        var targetY:Float = buttonTargetYs[i];
        var unselectedTargetY:Float = targetY + (menuButtons[i].y - selectionBeams[i].y);
        var selectedTargetY:Float = targetY + (menuButtonsSelected[i].y - selectionBeams[i].y);

        menuButtons[i].y = unselectedTargetY;
        menuButtonsSelected[i].y = selectedTargetY;
        selectionBeams[i].y = targetY;
    }
}

var inFreeplay:Bool = false;

var songTimes:Array<Array<Int>> = [
    [0, 0, 0, 0, 0, 3],
    [1, 3, 5, 9, 0, 4],
    [1, 7, 2, 5, 0, 4],
    [2, 1, 5, 4, 0, 4],
    [1, 1, 2, 8, 0, 5],
    [1, 5, 5, 5, 0, 5],
    [2, 1, 2, 9, 0, 5],
    [1, 3, 1, 7, 0, 6],
    [1, 5, 3, 3, 0, 6],
    [1, 6, 4, 5, 0, 6],
    [1, 4, 1, 7, 0, 7],
    [1, 4, 2, 0, 0, 7],
    [1, 4, 2, 3, 0, 7],
    [1, 4, 2, 7, 0, 7],
    [1, 8, 3, 9, 0, 8],
    [1, 8, 4, 1, 0, 8],
    [1, 8, 4, 4, 0, 8],
    [0, 8, 5, 7, 0, 9],
    [0, 9, 0, 0, 0, 9],
    [0, 9, 0, 4, 0, 9],
    [0, 9, 1, 1, 0, 9],
    [0, 9, 1, 5, 0, 9],
    [0, 9, 1, 5, 4, 9],
    [1, 0, 4, 9, 0, 9],
    [1, 2, 1, 3, 0, 9],
    [1, 9, 0, 4, 0, 9],
    [1, 9, 2, 1, 0, 9],
    [1, 9, 3, 2, 0, 9],
    [2, 3, 5, 9, 0, 9],
    [0, 0, 0, 8, 1, 0]
];

var numSuffixes:Array<String> = [
    "first",
    "second",
    "third",
    "fourth",
    "fith",
    "sixth"
];

var activeNumberTweens:Array<FlxTween> = [];
var activeSoundTimers:Array<FlxTimer> = [];

var freeplayRight1:FlxSprite;
var freeplayRight2:FlxSprite;
var freeplayRight3:FlxSprite;
var freeplayRight4:FlxSprite;
var freeplayRight5:FlxSprite;
var freeplayRight6:FlxSprite;
var freeplayLightRays:FlxSprite;

var freeplayNum1:FlxSprite;
var freeplayNum2:FlxSprite;
var freeplayNum3:FlxSprite;
var freeplayNum4:FlxSprite;
var freeplayNum5:FlxSprite;
var freeplayNum6:FlxSprite;
var freeplayJan:FlxSprite;

var fpRight1TargetX:Float = 0;
var fpRight1TargetY:Float = -200;
var fpRight2TargetX:Float = 500;
var fpRight2TargetY:Float = -30;
var fpRight3TargetX:Float = 300;
var fpRight3TargetY:Float = -20;
var fpRight4TargetX:Float = -550;
var fpRight4TargetY:Float = 100;
var fpRight5TargetX:Float = 150;
var fpRight5TargetY:Float = 200;
var fpRight6TargetX:Float = 250;
var fpRight6TargetY:Float = 0;

var fpRight6LightTargetX:Float = 300;
var fpRight6LightTargetY:Float = 300;
var fpRight6DarkTargetX:Float = 250;
var fpRight6DarkTargetY:Float = 0;


var fpLightRaysTargetX:Float = 0;
var fpLightRaysTargetY:Float = -250;

var fpNum1TargetX:Float = 351.5;
var fpNum1TargetY:Float = 17;
var fpNum2TargetX:Float = 397.5;
var fpNum2TargetY:Float = 13;
var fpNum3TargetX:Float = 481.5;
var fpNum3TargetY:Float = 7;
var fpNum4TargetX:Float = 546.5;
var fpNum4TargetY:Float = 4;
var fpNum5TargetX:Float = 617.5;
var fpNum5TargetY:Float = -53;
var fpNum6TargetX:Float = 641.5;
var fpNum6TargetY:Float = -56;
var fpJanTargetX:Float = 319;
var fpJanTargetY:Float = 4;

var freeplayConfig:Dynamic = {
    slideOutDuration: 0.6,
    slideOutEase: FlxEase.expoIn,
    
    slideInDuration: 0.65,
    slideInEase: FlxEase.expoOut,
    slideInDelay: 0.5,

    blurOpenAmount: 0.15,
    blurExitAmount: 0.25,

    layerOrder: [
        "right1",
        "right3",
        "right2",
        "right4",
        "right5",
        "right6",
        "right6light",
        "right6dark",
        "lightRays",
        "num1",
        "num2",
        "num3",
        "num4",
        "num5",
        "num6",
        "jan"
    ],

    right1Scale: 1.5,
    right2Scale: 1.0,
    right3Scale: 1.7,
    right4Scale: 1.3,
    right5Scale: 0.65,
    right6Scale: 1.3,
    right6LightScale: 1.3,
    right6DarkScale: 1.3,
    lightRaysScale: 0.7,

    clockMasterScale: 0.65,

    num1Scale: 1.0,
    num2Scale: 1.0,
    num3Scale: 1.0,
    num4Scale: 1.0,
    num5Scale: 1.0,
    num6Scale: 1.0,
    janScale: 1.0
};

var freeplayLayerVisibility:Dynamic = {
    showRight1: true,
    showRight2: true,
    showRight3: true,
    showRight4: true,
    showRight5: true,
    showRight6: true,
    showRight6Light: false,
    showRight6Dark: false,
    showLightRays: true,

    showNum1: true,
    showNum2: true,
    showNum3: true,
    showNum4: true,
    showNum5: true,
    showNum6: true,
    showJan: true
};

function buildFreeplaySprites() {
    var offscreenXOffset:Float = FlxG.width * 1.5;

    freeplayRight1 = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/freeplay/right1"));
    freeplayRight1.scale.set(freeplayConfig.right1Scale, freeplayConfig.right1Scale);
    freeplayRight1.updateHitbox();
    freeplayRight1.antialiasing = true;
    freeplayRight1.screenCenter();
    fpRight1TargetX = freeplayRight1.x + 0;
    fpRight1TargetY = freeplayRight1.y - 200;
    freeplayRight1.x = fpRight1TargetX + offscreenXOffset;
    freeplayRight1.y = fpRight1TargetY;
    freeplayRight1.alpha = 0;
    freeplayRight1.visible = freeplayLayerVisibility.showRight1;

    freeplayRight2 = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/freeplay/right2"));
    freeplayRight2.scale.set(freeplayConfig.right2Scale, freeplayConfig.right2Scale);
    freeplayRight2.updateHitbox();
    freeplayRight2.antialiasing = true;
    freeplayRight2.screenCenter();
    fpRight2TargetX = freeplayRight2.x + 500;
    fpRight2TargetY = freeplayRight2.y - 30;
    freeplayRight2.x = fpRight2TargetX + offscreenXOffset;
    freeplayRight2.y = fpRight2TargetY;
    freeplayRight2.alpha = 0;
    freeplayRight2.visible = freeplayLayerVisibility.showRight2;

    freeplayRight3 = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/freeplay/right3"));
    freeplayRight3.scale.set(freeplayConfig.right3Scale, freeplayConfig.right3Scale);
    freeplayRight3.updateHitbox();
    freeplayRight3.antialiasing = true;
    freeplayRight3.screenCenter();
    fpRight3TargetX = freeplayRight3.x + 300;
    fpRight3TargetY = freeplayRight3.y - 20;
    freeplayRight3.x = fpRight3TargetX + offscreenXOffset;
    freeplayRight3.y = fpRight3TargetY;
    freeplayRight3.alpha = 0;
    freeplayRight3.visible = freeplayLayerVisibility.showRight3;

    freeplayRight4 = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/freeplay/right4"));
    freeplayRight4.scale.set(freeplayConfig.right4Scale, freeplayConfig.right4Scale);
    freeplayRight4.updateHitbox();
    freeplayRight4.antialiasing = true;
    freeplayRight4.screenCenter();
    fpRight4TargetX = freeplayRight4.x - 550;
    fpRight4TargetY = freeplayRight4.y + 100;
    freeplayRight4.x = fpRight4TargetX + offscreenXOffset;
    freeplayRight4.y = fpRight4TargetY;
    freeplayRight4.alpha = 0;
    freeplayRight4.visible = freeplayLayerVisibility.showRight4;

    freeplayRight5 = new FlxSprite(0, 0);
    freeplayRight5.frames = Paths.getSparrowAtlas("menus/freeplay/right5");
    freeplayRight5.animation.addByPrefix("layer5", "layer5", 10, true);
    freeplayRight5.animation.play("layer5");
    freeplayRight5.scale.set(freeplayConfig.right5Scale, freeplayConfig.right5Scale);
    freeplayRight5.updateHitbox();
    freeplayRight5.antialiasing = true;
    freeplayRight5.screenCenter();
    fpRight5TargetX = freeplayRight5.x + 150;
    fpRight5TargetY = freeplayRight5.y + 200;
    freeplayRight5.x = fpRight5TargetX + offscreenXOffset;
    freeplayRight5.y = fpRight5TargetY;
    freeplayRight5.alpha = 0;
    freeplayRight5.visible = freeplayLayerVisibility.showRight5;

    freeplayRight6 = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/freeplay/right6"));
    freeplayRight6.scale.set(freeplayConfig.right6Scale, freeplayConfig.right6Scale);
    freeplayRight6.updateHitbox();
    freeplayRight6.antialiasing = true;
    freeplayRight6.screenCenter();
    fpRight6TargetX = freeplayRight6.x + 250;
    fpRight6TargetY = freeplayRight6.y + 0;
    freeplayRight6.x = fpRight6TargetX + offscreenXOffset;
    freeplayRight6.y = fpRight6TargetY;
    freeplayRight6.alpha = 0;
    freeplayRight6.visible = freeplayLayerVisibility.showRight6;

    freeplayRight6Light = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/freeplay/right6light"));
    freeplayRight6Light.scale.set(freeplayConfig.right6LightScale, freeplayConfig.right6LightScale);
    freeplayRight6Light.updateHitbox();
    freeplayRight6Light.antialiasing = true;
    freeplayRight6Light.screenCenter();
    fpRight6LightTargetX = freeplayRight6Light.x + 300;
    fpRight6LightTargetY = freeplayRight6Light.y + 50;
    freeplayRight6Light.x = fpRight6LightTargetX + offscreenXOffset;
    freeplayRight6Light.y = fpRight6LightTargetY;
    freeplayRight6Light.alpha = 0;
    freeplayRight6Light.visible = freeplayLayerVisibility.showRight6Light;

    freeplayRight6Dark = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/freeplay/right6dark"));
    freeplayRight6Dark.scale.set(freeplayConfig.right6DarkScale, freeplayConfig.right6DarkScale);
    freeplayRight6Dark.updateHitbox();
    freeplayRight6Dark.antialiasing = true;
    freeplayRight6Dark.screenCenter();
    fpRight6DarkTargetX = freeplayRight6Dark.x + 500;
    fpRight6DarkTargetY = freeplayRight6Dark.y + 50;
    freeplayRight6Dark.x = fpRight6DarkTargetX + offscreenXOffset;
    freeplayRight6Dark.y = fpRight6DarkTargetY;
    freeplayRight6Dark.alpha = 0;
    freeplayRight6Dark.visible = freeplayLayerVisibility.showRight6Dark;

    freeplayLightRays = new FlxSprite(0, 0);
    freeplayLightRays.frames = Paths.getSparrowAtlas("menus/freeplay/rightLightRays");
    freeplayLightRays.animation.addByPrefix("right2", "right2", 10, true);
    freeplayLightRays.animation.play("right2");
    freeplayLightRays.scale.set(freeplayConfig.lightRaysScale, freeplayConfig.lightRaysScale);
    freeplayLightRays.updateHitbox();
    freeplayLightRays.antialiasing = true;
    freeplayLightRays.screenCenter();
    fpLightRaysTargetX = freeplayLightRays.x + 250;
    fpLightRaysTargetY = freeplayLightRays.y - 250;
    freeplayLightRays.x = fpLightRaysTargetX + offscreenXOffset;
    freeplayLightRays.y = fpLightRaysTargetY;
    freeplayLightRays.alpha = 0;
    freeplayLightRays.visible = freeplayLayerVisibility.showLightRays;

    var mScale:Float = freeplayConfig.clockMasterScale;
    var mX:Float = 189;
    var mY:Float = 17;
    var spacing:Float = 100.0 * mScale;
    var totalClusterWidth:Float = spacing * 5;
    var startCenterX:Float = (FlxG.width / 2) - (totalClusterWidth / 2);

    freeplayNum1 = new FlxSprite(0, 0);
    freeplayNum1.frames = Paths.getSparrowAtlas("menus/freeplay/num1");
    freeplayNum1.animation.addByPrefix("8first", "8first", 10, true);
    freeplayNum1.animation.play("8first");
    var scale1:Float = freeplayConfig.num1Scale * mScale;
    freeplayNum1.scale.set(scale1, scale1);
    freeplayNum1.updateHitbox();
    freeplayNum1.antialiasing = true;
    freeplayNum1.screenCenter();
    fpNum1TargetX = startCenterX + (spacing * 0) + mX + 0;
    fpNum1TargetY = freeplayNum1.y + mY + 0;
    freeplayNum1.x = fpNum1TargetX + offscreenXOffset;
    freeplayNum1.y = fpNum1TargetY;
    freeplayNum1.alpha = 0;
    freeplayNum1.visible = freeplayLayerVisibility.showNum1;

    freeplayNum2 = new FlxSprite(0, 0);
    freeplayNum2.frames = Paths.getSparrowAtlas("menus/freeplay/num2");
    freeplayNum2.animation.addByPrefix("8second", "8second", 10, true);
    freeplayNum2.animation.play("8second");
    var scale2:Float = freeplayConfig.num2Scale * mScale;
    freeplayNum2.scale.set(scale2, scale2);
    freeplayNum2.updateHitbox();
    freeplayNum2.antialiasing = true;
    freeplayNum2.screenCenter();
    fpNum2TargetX = startCenterX + (spacing * 1) + mX - 19;
    fpNum2TargetY = freeplayNum2.y + mY - 4;
    freeplayNum2.x = fpNum2TargetX + offscreenXOffset;
    freeplayNum2.y = fpNum2TargetY;
    freeplayNum2.alpha = 0;
    freeplayNum2.visible = freeplayLayerVisibility.showNum2;

    freeplayNum3 = new FlxSprite(0, 0);
    freeplayNum3.frames = Paths.getSparrowAtlas("menus/freeplay/num3");
    freeplayNum3.animation.addByPrefix("8third", "8third", 10, true);
    freeplayNum3.animation.play("8third");
    var scale3:Float = freeplayConfig.num3Scale * mScale;
    freeplayNum3.scale.set(scale3, scale3);
    freeplayNum3.updateHitbox();
    freeplayNum3.antialiasing = true;
    freeplayNum3.screenCenter();
    fpNum3TargetX = startCenterX + (spacing * 2) + mX + 0;
    fpNum3TargetY = freeplayNum3.y + mY - 10;
    freeplayNum3.x = fpNum3TargetX + offscreenXOffset;
    freeplayNum3.y = fpNum3TargetY;
    freeplayNum3.alpha = 0;
    freeplayNum3.visible = freeplayLayerVisibility.showNum3;

    freeplayNum4 = new FlxSprite(0, 0);
    freeplayNum4.frames = Paths.getSparrowAtlas("menus/freeplay/num4");
    freeplayNum4.animation.addByPrefix("8fourth", "8fourth", 10, true);
    freeplayNum4.animation.play("8fourth");
    var scale4:Float = freeplayConfig.num4Scale * mScale;
    freeplayNum4.scale.set(scale4, scale4);
    freeplayNum4.updateHitbox();
    freeplayNum4.antialiasing = true;
    freeplayNum4.screenCenter();
    fpNum4TargetX = startCenterX + (spacing * 3) + mX - 3;
    fpNum4TargetY = freeplayNum4.y + mY - 13;
    freeplayNum4.x = fpNum4TargetX + offscreenXOffset;
    freeplayNum4.y = fpNum4TargetY;
    freeplayNum4.alpha = 0;
    freeplayNum4.visible = freeplayLayerVisibility.showNum4;

    freeplayNum5 = new FlxSprite(0, 0);
    freeplayNum5.frames = Paths.getSparrowAtlas("menus/freeplay/num5");
    freeplayNum5.animation.addByPrefix("8fith", "8fith", 10, true);
    freeplayNum5.animation.play("8fith");
    var scale5:Float = freeplayConfig.num5Scale * mScale;
    freeplayNum5.scale.set(scale5, scale5);
    freeplayNum5.updateHitbox();
    freeplayNum5.antialiasing = true;
    freeplayNum5.screenCenter();
    fpNum5TargetX = startCenterX + (spacing * 4) + mX + 3;
    fpNum5TargetY = freeplayNum5.y + mY - 70;
    freeplayNum5.x = fpNum5TargetX + offscreenXOffset;
    freeplayNum5.y = fpNum5TargetY;
    freeplayNum5.alpha = 0;
    freeplayNum5.visible = freeplayLayerVisibility.showNum5;

    freeplayNum6 = new FlxSprite(0, 0);
    freeplayNum6.frames = Paths.getSparrowAtlas("menus/freeplay/num6");
    freeplayNum6.animation.addByPrefix("8sixth", "8sixth", 10, true);
    freeplayNum6.animation.play("8sixth");
    var scale6:Float = freeplayConfig.num6Scale * mScale;
    freeplayNum6.scale.set(scale6, scale6);
    freeplayNum6.updateHitbox();
    freeplayNum6.antialiasing = true;
    freeplayNum6.screenCenter();
    fpNum6TargetX = startCenterX + (spacing * 5) + mX - 38;
    fpNum6TargetY = freeplayNum6.y + mY - 73;
    freeplayNum6.x = fpNum6TargetX + offscreenXOffset;
    freeplayNum6.y = fpNum6TargetY;
    freeplayNum6.alpha = 0;
    freeplayNum6.visible = freeplayLayerVisibility.showNum6;

    freeplayJan = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/freeplay/jan"));
    var scaleJan:Float = freeplayConfig.janScale * mScale;
    freeplayJan.scale.set(scaleJan, scaleJan);
    freeplayJan.updateHitbox();
    freeplayJan.antialiasing = true;
    freeplayJan.screenCenter();
    fpJanTargetX = freeplayJan.x + mX + 130;
    fpJanTargetY = freeplayJan.y + mY - 13;
    freeplayJan.x = fpJanTargetX + offscreenXOffset;
    freeplayJan.y = fpJanTargetY;
    freeplayJan.alpha = 0;
    freeplayJan.visible = freeplayLayerVisibility.showJan;

    var layerMap:Map<String, FlxSprite> = [
        "right1" => freeplayRight1,
        "right2" => freeplayRight2,
        "right3" => freeplayRight3,
        "right4" => freeplayRight4,
        "right5" => freeplayRight5,
        "right6" => freeplayRight6,
        "right6light" => freeplayRight6Light,
        "right6dark" => freeplayRight6Dark,
        "lightRays" => freeplayLightRays,
        "num1" => freeplayNum1,
        "num2" => freeplayNum2,
        "num3" => freeplayNum3,
        "num4" => freeplayNum4,
        "num5" => freeplayNum5,
        "num6" => freeplayNum6,
        "jan" => freeplayJan
    ];

    var orderList:Array<String> = freeplayConfig.layerOrder;
    for (layerKey in orderList) {
        if (layerMap.exists(layerKey)) {
            add(layerMap.get(layerKey));
        }
    }
}

function buildFreeplaySongList() {
    songs = [];
    
    var songList = FreeplaySonglist.get();
    if (songList != null && songList.songs != null) {
        songs = songList.songs;
    }

    grpSongs = new FlxTypedGroup<FlxText>();
    add(grpSongs);

    var offscreenXOffset:Float = FlxG.width * 1.5;

    for (i in 0...songs.length) {
        var s = songs[i];
        var songName:String = "Unknown";

        if (s != null) {
            if (s.displayName != null && s.displayName != "") {
                songName = s.displayName;
            } else if (s.name != null) {
                songName = s.name;
            }
        }
        
        var songText:FlxText = new FlxText(songListPos.x + offscreenXOffset, (i * songListPos.spacing) + songListPos.y, 0, songName, songListPos.size);
        songText.setFormat(Paths.font("vcr.ttf"), songListPos.size, 0xFFFFFFFF, "left");
        songText.ID = i;
        songText.alpha = 0;
        grpSongs.add(songText);
    }
}

function changeFreeplaySelection(change:Int = 0, playSound:Bool = true) {
    if (songs.length == 0) return;

    if (playSound && change != 0) {
        FlxG.sound.play(Paths.sound("menus/scroll"));
    }

    curFreeplaySelected += change;

    if (curFreeplaySelected < 0)
        curFreeplaySelected = songs.length - 1;
    if (curFreeplaySelected >= songs.length)
        curFreeplaySelected = 0;

    for (item in grpSongs.members) {
        var relY:Int = item.ID - curFreeplaySelected;
        item.alpha = (relY == 0) ? 1.0 : 0.6;
    }

    triggerClockSequence(curFreeplaySelected);
}

function updateFreeplaySongList(elapsed:Float) {
    if (grpSongs == null) return;

    for (item in grpSongs.members) {
        var relY:Int = item.ID - curFreeplaySelected;
        var targetYPos:Float = (relY * songListPos.spacing) + songListPos.y;
        
        item.y = FlxMath.lerp(item.y, targetYPos, FlxMath.bound(elapsed * 20 * songListPos.lerpSpeed, 0, 1));
    }
}

function selectFreeplaySong() {
    if (songs.length == 0 || curFreeplaySelected < 0 || curFreeplaySelected >= songs.length) return;

    canInteract = false;
    FlxG.sound.play(Paths.sound("menus/confirm"));

    var selectedSong = songs[curFreeplaySelected];
    PlayState.loadSong(selectedSong.name, "hard");

    if (freeplayMusic != null) {
        freeplayMusic.stop();
        freeplayMusic.destroy();
        freeplayMusic = null;
    }

    triggerBurnTransition(function() {
        FlxG.switchState(new PlayState());
    });
}

function openFreeplay() {
    canInteract = false;
    inMainMenu = false;

    if (FlxG.sound.music != null) {
        FlxTween.num(FlxG.sound.music.volume, 0, audioConfig.menuToFreeplayOutDuration, {
            startDelay: audioConfig.menuToFreeplayOutDelay,
            onUpdate: function(t:FlxTween) {
                if (FlxG.sound.music != null) FlxG.sound.music.volume = t.value;
            }
        });
    }

    if (grpSongs != null) {
        for (item in grpSongs.members) {
            var relY:Int = item.ID - curFreeplaySelected;
            var targetAlpha:Float = (relY == 0) ? 1.0 : 0.6;

            FlxTween.tween(item, {x: songListPos.x, alpha: targetAlpha}, freeplayConfig.slideInDuration, {
                ease: freeplayConfig.slideInEase,
                startDelay: freeplayConfig.slideInDelay
            });
        }
    }

    freeplayMusic = FlxG.sound.play(Paths.music("freeplay"), 0, true);
    if (freeplayMusic != null) {
        FlxTween.num(0, audioConfig.freeplayTargetVolume, audioConfig.freeplayInDuration, {
            startDelay: audioConfig.freeplayInDelay,
            onUpdate: function(t:FlxTween) {
                if (freeplayMusic != null) freeplayMusic.volume = t.value;
            }
        });
    }

    FlxTween.num(blurShader.strength, freeplayConfig.blurOpenAmount, freeplayConfig.slideOutDuration, {
        ease: freeplayConfig.slideOutEase,
        onUpdate: function(tween:FlxTween) {
            blurShader.strength = tween.value;
        }
    });

    transitionToFreeplayLayout(function() {
        FlxTween.num(blurShader.strength, 0.0, freeplayConfig.slideInDuration, {
            ease: freeplayConfig.slideInEase,
            onUpdate: function(tween:FlxTween) {
                blurShader.strength = tween.value;
            }
        });

        inFreeplay = true;
        canInteract = true;
    });

    var fpLayers:Array<Dynamic> = [
        {sprite: freeplayRight1, targetX: fpRight1TargetX},
        {sprite: freeplayRight2, targetX: fpRight2TargetX},
        {sprite: freeplayRight3, targetX: fpRight3TargetX},
        {sprite: freeplayRight4, targetX: fpRight4TargetX},
        {sprite: freeplayRight5, targetX: fpRight5TargetX},
        {sprite: freeplayRight6, targetX: fpRight6TargetX},
        {sprite: freeplayRight6Light, targetX: fpRight6LightTargetX},
        {sprite: freeplayRight6Dark, targetX: fpRight6DarkTargetX},
        {sprite: freeplayLightRays, targetX: fpLightRaysTargetX},
        {sprite: freeplayNum1, targetX: fpNum1TargetX},
        {sprite: freeplayNum2, targetX: fpNum2TargetX},
        {sprite: freeplayNum3, targetX: fpNum3TargetX},
        {sprite: freeplayNum4, targetX: fpNum4TargetX},
        {sprite: freeplayNum5, targetX: fpNum5TargetX},
        {sprite: freeplayNum6, targetX: fpNum6TargetX},
        {sprite: freeplayJan, targetX: fpJanTargetX}
    ];

    for (layerData in fpLayers) {
        var spr:FlxSprite = layerData.sprite;
        var finalX:Float = layerData.targetX;

        if (spr != null) {
            FlxTween.tween(spr, {x: finalX, alpha: 1}, freeplayConfig.slideInDuration, {
                ease: freeplayConfig.slideInEase,
                startDelay: freeplayConfig.slideInDelay
            });
        }
    }
}

function exitFreeplay() {
    canInteract = false;
    inFreeplay = false;

    FlxG.sound.play(Paths.sound("menus/cancel"));

    FlxTween.num(blurShader.strength, freeplayConfig.blurExitAmount, freeplayConfig.slideOutDuration, {
        ease: freeplayConfig.slideOutEase,
        onUpdate: function(tween:FlxTween) {
            blurShader.strength = tween.value;
        }
    });

    if (freeplayMusic != null) {
        FlxTween.num(freeplayMusic.volume, 0, audioConfig.freeplayOutDuration, {
            startDelay: audioConfig.freeplayOutDelay,
            onUpdate: function(t:FlxTween) {
                if (freeplayMusic != null) freeplayMusic.volume = t.value;
            },
            onComplete: function(_) {
                if (freeplayMusic != null) {
                    freeplayMusic.stop();
                    freeplayMusic.destroy();
                    freeplayMusic = null;
                }
            }
        });
    }

    if (FlxG.sound.music != null) {
        FlxTween.num(FlxG.sound.music.volume, audioConfig.freeplayToMenuTargetVolume, audioConfig.freeplayToMenuInDuration, {
            startDelay: audioConfig.freeplayToMenuInDelay,
            onUpdate: function(t:FlxTween) {
                if (FlxG.sound.music != null) FlxG.sound.music.volume = t.value;
            }
        });
    }

    var offscreenXOffset:Float = FlxG.width * 1.5;
    var dur:Float = freeplayConfig.slideOutDuration;
    var easeType = freeplayConfig.slideOutEase;

    if (grpSongs != null) {
        for (item in grpSongs.members) {
            FlxTween.tween(item, {x: songListPos.x + offscreenXOffset, alpha: 0}, dur, {
                ease: easeType
            });
        }
    }

    var fpLayers:Array<FlxSprite> = [
        freeplayRight1, freeplayRight2, freeplayRight3, freeplayRight4,
        freeplayRight5, freeplayRight6, freeplayLightRays, freeplayNum1,
        freeplayNum2, freeplayNum3, freeplayNum4, freeplayNum5,
        freeplayNum6, freeplayJan
    ];

    for (spr in fpLayers) {
        if (spr != null) {
            FlxTween.tween(spr, {x: spr.x + offscreenXOffset, alpha: 0}, dur, {ease: easeType});
        }
    }

    var xMod:Float = -FlxG.height * 0;
    FlxTween.tween(lightRays, {alpha: 1}, freeplayConfig.slideInDuration, {
        ease: freeplayConfig.slideInEase,
        startDelay: freeplayConfig.slideInDelay
    });

    FlxTween.tween(layer1, {x: layer1TargetX, alpha: 1}, freeplayConfig.slideInDuration, {ease: freeplayConfig.slideInEase, startDelay: freeplayConfig.slideInDelay});
    FlxTween.tween(layer2, {x: layer2TargetX, alpha: 1}, freeplayConfig.slideInDuration, {ease: freeplayConfig.slideInEase, startDelay: freeplayConfig.slideInDelay});
    FlxTween.tween(layer3, {x: layer3TargetX, alpha: 1}, freeplayConfig.slideInDuration, {ease: freeplayConfig.slideInEase, startDelay: freeplayConfig.slideInDelay});
    FlxTween.tween(layer4, {x: layer4TargetX, alpha: 1}, freeplayConfig.slideInDuration, {ease: freeplayConfig.slideInEase, startDelay: freeplayConfig.slideInDelay});
    FlxTween.tween(layer5, {x: layer5TargetX, alpha: 1}, freeplayConfig.slideInDuration, {ease: freeplayConfig.slideInEase, startDelay: freeplayConfig.slideInDelay});
    FlxTween.tween(floatingBF, {x: floatingBF.x - (-FlxG.width * 1.2), alpha: 1}, freeplayConfig.slideInDuration, {ease: freeplayConfig.slideInEase, startDelay: freeplayConfig.slideInDelay});

    var totalButtons:Int = menuButtons.length;
    var completedButtons:Int = 0;

    for (i in 0...totalButtons) {
        var delayTime:Float = 0.05 * i;
        var baseTargetX:Float = buttonTargetXs[i];

        FlxTween.tween(menuButtons[i], {x: baseTargetX, alpha: (i == curSelected ? 0.3 : 0.3)}, freeplayConfig.slideInDuration, {
            ease: freeplayConfig.slideInEase,
            startDelay: freeplayConfig.slideInDelay + delayTime
        });
        FlxTween.tween(menuButtonsSelected[i], {x: baseTargetX, alpha: 1}, freeplayConfig.slideInDuration, {
            ease: freeplayConfig.slideInEase,
            startDelay: freeplayConfig.slideInDelay + delayTime
        });
        FlxTween.tween(selectionBeams[i], {x: baseTargetX, alpha: 0.2}, freeplayConfig.slideInDuration, {
            ease: freeplayConfig.slideInEase,
            startDelay: freeplayConfig.slideInDelay + delayTime,
            onStart: function(_) {
                if (i == 0) {
                    FlxTween.num(blurShader.strength, 0.0, freeplayConfig.slideInDuration, {
                        ease: freeplayConfig.slideInEase,
                        onUpdate: function(tween:FlxTween) {
                            blurShader.strength = tween.value;
                        }
                    });
                }
            },
            onComplete: function(_) {
                completedButtons++;
                if (completedButtons >= totalButtons) {
                    inMainMenu = true;
                    canInteract = true;
                }
            }
        });
    }
}

function triggerClockSequence(songIndex:Int) {
    for (t in activeNumberTweens) {
        if (t != null) t.cancel();
    }
    activeNumberTweens = [];

    for (tm in activeSoundTimers) {
        if (tm != null) tm.cancel();
    }
    activeSoundTimers = [];

    var targetDigits:Array<Int> = [1, 2, 3, 4, 5, 6];
    if (songTimes.length > 0) {
        var safeIndex:Int = songIndex % songTimes.length;
        if (safeIndex < 0) safeIndex += songTimes.length;
        targetDigits = songTimes[safeIndex];
    }

    var numSprites:Array<FlxSprite> = [
        freeplayNum1,
        freeplayNum2,
        freeplayNum3,
        freeplayNum4,
        freeplayNum5,
        freeplayNum6
    ];

    var lastChosenDigits:Array<Int> = [-1, -1, -1, -1, -1, -1];
    var stepDelay:Float = 0.08;

    for (step in 0...5) {
        var isFinalStep:Bool = (step == 4);

        var tmr:FlxTimer = new FlxTimer().start(step * stepDelay, function(_) {
            FlxG.sound.play(Paths.sound("menus/clockTick" + step));

            var currentStepDigits:Array<Int> = [];

            for (i in 0...numSprites.length) {
                var spr:FlxSprite = numSprites[i];
                if (spr == null) continue;

                var digit:Int = 0;

                if (isFinalStep) {
                    digit = targetDigits[i];
                } else {
                    var candidate:Int = FlxG.random.int(0, 9);
                    var attempts:Int = 0;

                    while (attempts < 10) {
                        var repeatsPrevious:Bool = (candidate == lastChosenDigits[i]);
                        var matchesNeighbor:Bool = (i > 0 && currentStepDigits.length > 0 && candidate == currentStepDigits[i - 1]);

                        if (!repeatsPrevious && !matchesNeighbor) {
                            break;
                        }

                        candidate = FlxG.random.int(0, 9);
                        attempts++;
                    }

                    digit = candidate;
                }

                currentStepDigits.push(digit);
                lastChosenDigits[i] = digit;

                var animName:String = digit + numSuffixes[i];

                if (spr.animation.getByName(animName) == null) {
                    spr.animation.addByPrefix(animName, animName, 10, true);
                }
                spr.animation.play(animName);

                applyNumberOffset(spr, digit, i);
            }
        });

        activeSoundTimers.push(tmr);
    }
}

function applyNumberOffset(spr:FlxSprite, digit:Int, numberIndex:Int) {
    switch (numberIndex) {
        case 0:
            applyNum1Offset(spr, digit);
        case 1:
            applyNum2Offset(spr, digit);
        case 2:
            applyNum3Offset(spr, digit);
        case 3:
            applyNum4Offset(spr, digit);
        case 4:
            applyNum5Offset(spr, digit);
        case 5:
            applyNum6Offset(spr, digit);
    }
}

function applyNum1Offset(spr:FlxSprite, digit:Int) {
    var offsetX:Float = 0;
    var offsetY:Float = 0;

    switch (digit) {
        case 1:
            offsetX = -16;
            offsetY = 18;
        case 2:
            offsetX = 17;
            offsetY = 25;
        case 3:
            offsetX = 17;
            offsetY = 25;
        case 4:
            offsetX = 8;
            offsetY = 23;
        case 5:
            offsetX = 17;
            offsetY = 28;
        case 6:
            offsetX = 17;
            offsetY = 28;
        case 7:
            offsetX = -6;
            offsetY = 25;
        case 8:
            offsetX = 17;
            offsetY = 28;
        case 9:
            offsetX = 9;
            offsetY = 26;
        case 0:
            offsetX = 17;
            offsetY = 28;
    }

    spr.offset.set(offsetX, offsetY);
}

function applyNum2Offset(spr:FlxSprite, digit:Int) {
    var offsetX:Float = 0;
    var offsetY:Float = 0;

    switch (digit) {
        case 1:
            offsetX = -26;
            offsetY = 19;
        case 2:
            offsetX = 13;
            offsetY = 30;
        case 3:
            offsetX = 13;
            offsetY = 30;
        case 4:
            offsetX = 3;
            offsetY = 22;
        case 5:
            offsetX = 14;
            offsetY = 31;
        case 6:
            offsetX = 14;
            offsetY = 31;
        case 7:
            offsetX = -11;
            offsetY = 29;
        case 8:
            offsetX = 14;
            offsetY = 31;
        case 9:
            offsetX = 3;
            offsetY = 29;
        case 0:
            offsetX = 14;
            offsetY = 31;
    }

    spr.offset.set(offsetX, offsetY);
}

function applyNum3Offset(spr:FlxSprite, digit:Int) {
    var offsetX:Float = 0;
    var offsetY:Float = 0;

    switch (digit) {
        case 1:
            offsetX = -28;
            offsetY = 25;
        case 2:
            offsetX = 12;
            offsetY = 34;
        case 3:
            offsetX = 12;
            offsetY = 34;
        case 4:
            offsetX = 6;
            offsetY = 27;
        case 5:
            offsetX = 12;
            offsetY = 34;
        case 6:
            offsetX = 13;
            offsetY = 34;
        case 7:
            offsetX = -5;
            offsetY = 35;
        case 8:
            offsetX = 14;
            offsetY = 34;
        case 9:
            offsetX = 7;
            offsetY = 33;
        case 0:
            offsetX = 14;
            offsetY = 34;
    }

    spr.offset.set(offsetX, offsetY);
}

function applyNum4Offset(spr:FlxSprite, digit:Int) {
    var offsetX:Float = 0;
    var offsetY:Float = 0;

    switch (digit) {
        case 1:
            offsetX = -32;
            offsetY = 28;
        case 2:
            offsetX = 17;
            offsetY = 39;
        case 3:
            offsetX = 15;
            offsetY = 39;
        case 4:
            offsetX = 9;
            offsetY = 31;
        case 5:
            offsetX = 12;
            offsetY = 38;
        case 6:
            offsetX = 17;
            offsetY = 38;
        case 7:
            offsetX = -2;
            offsetY = 37;
        case 8:
            offsetX = 17;
            offsetY = 38;
        case 9:
            offsetX = 10;
            offsetY = 37;
        case 0:
            offsetX = 17;
            offsetY = 38;
    }

    spr.offset.set(offsetX, offsetY);
}

function applyNum5Offset(spr:FlxSprite, digit:Int) {
    var offsetX:Float = 0;
    var offsetY:Float = 0;

    switch (digit) {
        case 1:
            offsetX = -13;
            offsetY = 10;
        case 2:
            offsetX = 5;
            offsetY = 12;
        case 3:
            offsetX = 5;
            offsetY = 12;
        case 4:
            offsetX = 5;
            offsetY = 12;
        case 5:
            offsetX = 5;
            offsetY = 12;
        case 6:
            offsetX = 5;
            offsetY = 12;
        case 7:
            offsetX = 0;
            offsetY = 12;
        case 8:
            offsetX = 5;
            offsetY = 12;
        case 9:
            offsetX = 5;
            offsetY = 12;
        case 0:
            offsetX = 5;
            offsetY = 12;
    }

    spr.offset.set(offsetX, offsetY);
}

function applyNum6Offset(spr:FlxSprite, digit:Int) {
    var offsetX:Float = 0;
    var offsetY:Float = 0;

    switch (digit) {
        case 1:
            offsetX = -13;
            offsetY = 10;
        case 2:
            offsetX = 5;
            offsetY = 12;
        case 3:
            offsetX = 2;
            offsetY = 12;
        case 4:
            offsetX = 5;
            offsetY = 12;
        case 5:
            offsetX = 5;
            offsetY = 12;
        case 6:
            offsetX = 5;
            offsetY = 12;
        case 7:
            offsetX = 0;
            offsetY = 12;
        case 8:
            offsetX = 5;
            offsetY = 12;
        case 9:
            offsetX = 5;
            offsetY = 12;
        case 0:
            offsetX = 5;
            offsetY = 12;
    }

    spr.offset.set(offsetX, offsetY);
}

function transitionToFreeplayLayout(onCompleteCallback:Void->Void) {
    var xMod:Float = -FlxG.width * 1.2;
    var dur:Float = freeplayConfig.slideOutDuration;
    var easeType = freeplayConfig.slideOutEase;

    FlxTween.tween(lightRays, {alpha: 0}, dur * 0.8);
    FlxTween.tween(layer1, {x: layer1.x + xMod, alpha: 0}, dur, {ease: easeType});
    FlxTween.tween(layer2, {x: layer2.x + xMod, alpha: 0}, dur, {ease: easeType});
    FlxTween.tween(layer3, {x: layer3.x + xMod, alpha: 0}, dur, {ease: easeType});
    FlxTween.tween(layer4, {x: layer4.x + xMod, alpha: 0}, dur, {ease: easeType});
    FlxTween.tween(layer5, {x: layer5.x + xMod, alpha: 0}, dur, {ease: easeType});
    FlxTween.tween(floatingBF, {x: floatingBF.x + xMod, alpha: 0}, dur, {ease: easeType});

    var totalButtons:Int = menuButtons.length;
    var completedButtons:Int = 0;

    for (i in 0...totalButtons) {
        var startXUnselected:Float = menuButtons[i].x;
        var startXSelected:Float = menuButtonsSelected[i].x;
        var startXBeam:Float = selectionBeams[i].x;

        FlxTween.tween(menuButtons[i], {x: startXUnselected + xMod, alpha: 0}, dur, {
            ease: easeType
        });
        FlxTween.tween(menuButtonsSelected[i], {x: startXSelected + xMod, alpha: 0}, dur, {
            ease: easeType
        });
        FlxTween.tween(selectionBeams[i], {x: startXBeam + xMod, alpha: 0}, dur, {
            ease: easeType,
            onComplete: function(_) {
                completedButtons++;
                if (completedButtons >= totalButtons) {
                    if (onCompleteCallback != null) {
                        onCompleteCallback();
                        changeFreeplaySelection(0, false);
                    }
                }
            }
        });
    }
}