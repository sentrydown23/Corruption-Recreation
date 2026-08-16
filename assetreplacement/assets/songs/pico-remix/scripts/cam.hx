function create()
{
    blackBox = new FlxSprite(0, 0);
    blackBox.makeGraphic(5000, 5000, 0xFF000000);
    blackBox.screenCenter();
    blackBox.scrollFactor.set(0, 0);
    blackBox.cameras = [camHUD];
    add(blackBox);
    blackBox.alpha = 0;
}

function postCreate() {
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    // Rating shit moved to global song script
    
}



function beatHit(_)
{
    switch(_)
    {
        case 450:
            blackBox.alpha = 0;
    }
}