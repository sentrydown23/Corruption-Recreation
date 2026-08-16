import funkin.game.PlayState;

var lightningStrike:Bool = true;
var lightningStrikeBeat:Int = 0;
var lightningOffset:Int = 8;
var thunderSFXamount:Int = 2;

var bgs:Array<Dynamic> = [];

function create() {
	for(i in 1...thunderSFXamount+1)
		FlxG.sound.load(Paths.sound('thunder_' + Std.string(i)));
		
	bgs = [bg1, bg2, bg3];

	for (bg in bgs) {
		if (bg != null) {
			bg.playAnim('idle');

			bg.animation.finishCallback = function(name:String) {
				if (name == 'lightning') {
					bg.playAnim('idle');
				}
			};
		}
	}
}

function postCreate()
{
    if (bgs.length < 3) return;

    if (bgs[0] != null) bgs[0].alpha = 0;
    if (bgs[1] != null) bgs[1].alpha = 0;
    if (bgs[2] != null) bgs[2].alpha = 0;

    switch(SONG.meta.name)
    {
        case "spookeez-remix":
            if (bgs[0] != null) bgs[0].alpha = 1;

        case "south-remix":
            if (bgs[1] != null) bgs[1].alpha = 1;

        case "chiller":
            if (bgs[2] != null) bgs[2].alpha = 1;
    }
}

function lightningStrikeShit()
{
	FlxG.sound.play(Paths.soundRandom('thunder_', 1, thunderSFXamount));
	
	for (bg in bgs) {
		if (bg != null) bg.playAnim('lightning');
	}

	lightningStrikeBeat = curBeat;
	lightningOffset = FlxG.random.int(8, 24);
}

function beatHit(curBeat) {
	if (lightningStrike && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
	{
		lightningStrikeShit();
	}
}
