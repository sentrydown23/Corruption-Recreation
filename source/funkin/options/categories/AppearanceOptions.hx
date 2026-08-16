package funkin.options.categories;

import funkin.options.type.*;

class AppearanceOptions extends TreeMenuScreen {
    public function new() {
        super('optionsTree.appearance-name', 'optionsTree.appearance-desc', 'AppearanceOptions.');

        add(new NumOption(getNameID('framerate'), getDescID('framerate'),
            30, 240, 1,
            'framerate', __changeFPS
        ));
        add(new Checkbox(getNameID('forcefull'), getDescID('forcefull'), 'forcefull', __changeFullscreen));

        add(new Separator());
        add(new TextOption('optionsMenu.advanced', 'optionsTree.appearance.advanced-desc', ' >', () ->
            parent.addMenu(new AdvancedAppearanceOptions())));
    }

    private function __changeFPS(value:Float) {
        var framerate = Math.floor(value);
        if (FlxG.updateFramerate < framerate) FlxG.drawFramerate = FlxG.updateFramerate = framerate;
        else FlxG.updateFramerate = FlxG.drawFramerate = framerate;
    }

    private function __changeFullscreen() {
        FlxG.fullscreen = Options.forcefull;
    }
}

class AdvancedAppearanceOptions extends TreeMenuScreen {
    var qualityOptions:Array<OptionType> = [];
    var disParticlesOption:Checkbox;

    public function new() {
        super('optionsMenu.advanced', 'optionsTree.appearance.advanced-desc', 'AppearanceOptions.Advanced.');

        add(new ArrayOption(getNameID('quality'), getDescID('quality'),
            [0, 1, 2], [getID('quality-low'), getID('quality-high'), getID('quality-custom')],
            'quality', __changeQuality, null
        ));

        disParticlesOption = new Checkbox(getNameID('disParticles'), getDescID('disParticles'), 'disParticles'); // leave it like this

        for (option in (qualityOptions = [
            new Checkbox(getNameID('antialiasing'), getDescID('antialiasing'), 'antialiasing', __changeAntialiasing),
            new Checkbox(getNameID('lowMemoryMode'), getDescID('lowMemoryMode'), 'lowMemoryMode', __changeLowMem),
            disParticlesOption,
            new Checkbox(getNameID('vigtoggle'), getDescID('vigtoggle'), 'vigtoggle'),
            new Checkbox(getNameID('gameplayShaders'), getDescID('gameplayShaders'), 'gameplayShaders')
        ])) 
            add(option);

        add(new Checkbox(getNameID('gpuOnlyBitmaps'), getDescID('gpuOnlyBitmaps'), 'gpuOnlyBitmaps'));

        updateQualityOptions();
    }

    private function updateQualityOptions() {
        for (option in qualityOptions) {
            option.locked = Options.quality != 2;

            if (option == disParticlesOption && !option.locked) {
                option.locked = !Options.lowMemoryMode;
            }

            if (option is Checkbox) {
                final checkbox:Checkbox = cast option;
                checkbox.checked = Reflect.field(checkbox.parent, checkbox.optionName);
            }
            else if (option is SliderOption) {
                final slider:SliderOption = cast option;
                slider.currentValue = Reflect.field(slider.parent, slider.optionName);
            }
            else if (option is NumOption) {
                final num:NumOption = cast option;
                num.currentValue = Reflect.field(num.parent, num.optionName);
            }
            else if (option is ArrayOption) {
                final array:ArrayOption = cast option;
                array.currentSelection = Reflect.field(array.parent, array.optionName);
            }
        }
    }

    private function __changeLowMem() {
        updateQualityOptions();
    }

    private function __changeQuality(value:Dynamic) {
        Options.applyQuality();
        updateQualityOptions();
    }

    private function __changeAntialiasing() {
        FlxG.game.stage.quality = (FlxG.enableAntialiasing = Options.antialiasing) ? BEST : LOW;
    }
}