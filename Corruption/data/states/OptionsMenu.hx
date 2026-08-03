import flixel.FlxSprite;

var bgDance:FlxSprite;

function create() {
    bgDance = new FlxSprite();
    bgDance.frames = Paths.getSparrowAtlas('menus/static');
    bgDance.animation.addByPrefix('idle', 'static idle dance', 12, true);
    bgDance.animation.play('idle');
    bgDance.screenCenter();
    bgDance.scrollFactor.set(0, 0); // Stops it from moving when scrolling menus
    add(bgDance);
}

function postCreate() {
    // Hide the original background so it doesn't block your character
    if (members.contains(bg)) {
        bg.visible = false; 
    }
}
