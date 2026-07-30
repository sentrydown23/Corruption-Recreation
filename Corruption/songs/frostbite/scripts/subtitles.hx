import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle; 
import flixel.tweens.FlxTween;
import funkin.game.HealthIcon;

// CONFIGURATION: Set this to false to completely hide and disable the icon
var showIcon:Bool = false; 

var subText:FlxText = null;
var subIcon:HealthIcon = null;

var textTween:FlxTween = null;
var iconTween:FlxTween = null;

function postCreate() {
    initSubtitles();
}

function beatHit(_)
{
    switch(_)
    {
        case 33, 64, 93, 122, 131, 144, 156, 168, 178, 196, 216, 224, 243, 257, 267, 274, 284, 296, 306, 318, 328, 338, 357, 392:
            lyric("", true);
    }
}

function stepHit(_)
{
    switch(_)
    {
        case 68:
            lyric("Your skin is freezing", false);
        case 100:
            lyric("Here, let me help", false);
        case 116:
            lyric("You take it off", false);

        case 192:
            lyric("Feasting with your friends", false);
        case 214:
            lyric("What a perfect way to end", false);
        case 228:
            lyric("All these lonely holidays", false);
        case 246:
            lyric("La-la, la-la!", false);

        case 322:
            lyric("Gonna take a piece", false);
        case 334:
            lyric("Of your rabies!", false);
        case 354:
            lyric("And vivisect your mind!", false);

        case 464:
            lyric("Snowmen smiling with your teeth", false);
        case 496:
            lyric("Fallen angels created", false);
        case 514:
            lyric("With", false);
        case 517:
            lyric("Your", false);
        case 520:
            lyric("Meat!", false);

        case 548:
            lyric("That pearly smile...", false);

        case 595:
            lyric("Cut in a thousand slices", false);
        case 608:
            lyric("Bake you 'til", false);
        case 616:
            lyric("Golden brown", false);

        case 656:
            lyric("Stuff you with spices", false);
        
        case 688:
            lyric("Serve to friends around!", false);

        case 720:
            lyric("Separate you from your eyes", false);
        case 738:
            lyric("Turn your girlfriend inside out and", false);
        case 752:
            lyric("Burn her fingernails", false);
        case 774:
            lyric("La-la, la-la!", false);

        case 848:
            lyric("Soak your hands in freezing water", false);
        
        case 880:
            lyric("Watching as the skin gets softer", false);
        
        case 912:
            lyric("See your bones appear in dark red snow", false);

        case 944:
            lyric("Drop fur-", false);
        case 955:
            lyric("Drop further", false);
        case 959:
            lyric("Drop further be-", false);
        case 967:
            lyric("Drop further below!", false);

        case 978:
            lyric("Gonna take a piece", false);
        case 990:
            lyric("Of your rabies!", false);
        case 1010:
            lyric("And vivisect your mind!", false);

        case 1042:
            lyric("Gonna take a peak", false);
        case 1052:
            lyric("Inside your head...", false);
        case 1074:
            lyric("And find the worm inside", false);

        case 1104:
            lyric("Cut in a thousand slices", false);
        case 1120:
            lyric("Bake you 'til", false);
        case 1128:
            lyric("Golden brown", false);

        case 1168:
            lyric("Fill you with spices", false);
        
        case 1200:
            lyric("Serve to friends around!", false);   

        case 1234:
            lyric("Turn the heat on high and", false);
        case 1248:
            lyric("We'll reduce your blood!", false);

        case 1296:
            lyric("Boil lil' boyfriend", false);

        case 1328:
            lyric("With brandy and plums!", false);

        case 1376:
            lyric("Gonna take a piece", false);
        case 1390:
            lyric("Of your rabies!", false);
        case 1410:
            lyric("And vivisect your mind!", false);

        case 1504:
            lyric("Separate you from your eyes", false);
        case 1522:
            lyric("Turn your girlfriend inside out and", false);
        case 1536:
            lyric("Burn her fingernails", false);
        case 1558:
            lyric("La-la, la-la!", false);

    }
}

function initSubtitles() {
    if (subText != null) return;

    subText = new FlxText(0, 540, 0, "", 28);
    subText.setFormat(Paths.font("vcr.ttf"), 28, 0xFFFFFFFF, "center");
    subText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2);
    subText.scrollFactor.set(0, 0);
    
    if (healthBar != null) {
        subText.y = healthBar.y - 150;
        subText.x = healthBar.x + (healthBar.width / 2);
    } else {
        subText.screenCenter("x");
    }

    if (camHUD != null) {
        subText.cameras = [camHUD];
    }

    add(subText);
    subText.alpha = 0;

    // Only build and add the icon if showIcon is true
    if (showIcon) {
        subIcon = new HealthIcon("monster-frostbite");
        subIcon.scale.set(0.7, 0.7);
        subIcon.updateHitbox();
        subIcon.scrollFactor.set(0, 0);

        if (healthBar != null) {
            subIcon.x = healthBar.x - 50; 
        } else {
            subIcon.x = 200; 
        }
        subIcon.y = subText.y - 30;

        if (camHUD != null) {
            subIcon.cameras = [camHUD];
        }

        add(subIcon);
        subIcon.alpha = 0;
    }
}

function lyric(text:String, hide:Bool) {
    if (subText == null) initSubtitles();

    if (textTween != null) textTween.cancel();
    if (iconTween != null) iconTween.cancel();

    if (hide == true || text == "") {
        textTween = FlxTween.tween(subText, {alpha: 0}, 0.2);
        if (showIcon && subIcon != null) {
            iconTween = FlxTween.tween(subIcon, {alpha: 0}, 0.2);
        }
        return;
    }

    subText.text = text;
    subText.drawFrame(true); 

    if (healthBar != null) {
        subText.x = (healthBar.x + (healthBar.width / 2)) - (subText.width / 2);
    } else {
        subText.screenCenter("x");
    }

    if (subText.alpha < 1) {
        textTween = FlxTween.tween(subText, {alpha: 1}, 0.2);
        if (showIcon && subIcon != null) {
            iconTween = FlxTween.tween(subIcon, {alpha: 1}, 0.2);
        }
    }
}
