import funkin.game.PlayState;


var curColor:Int = 0;
var trainSound:FlxSound;
var colors = [
	0xFF000000, // Pure Black
	0xFF333333, // Dark Charcoal Gray
	0xFF666666, // Medium Slate Gray
	0xFF999999, // Light Gray
	0xFFCCCCCC  // Silver / Off-White Gray
];

var sky:Array<FlxSprite> = [];

// hopefully copy-pasting this script from the source just kind of works


var trainMoving:Bool = false;
var trainFrameTiming:Float = 0;
var trainCars:Int = 8;
var trainFinishing:Bool = false;
var trainCooldown:Int = 0;

function create() {
	// defaultCamZoom = 0.5;
	phillyTrain.moves = true;
	light.color = colors[curColor];
	trainSound = FlxG.sound.load(Paths.sound("train_passes"));
}

function postCreate()
{
	sky.push(bg1);
	sky.push(bg2);
	sky.push(bg3);

	for (spr in sky) {
        spr.alpha = 0;
    }

	switch(SONG.meta.name)
	{
		case "pico-remix":
			sky[0].alpha = 1;

		case "philly-remix":
			sky[1].alpha = 1;

		case "full-clip":
			sky[2].alpha = 1;
	}
}
function beatHit(curBeat:Int) {
	if (curBeat % 4 == 0) {
		// switches color
		var newColor = FlxG.random.int(0, colors.length-2);
		if (newColor >= curColor) newColor++;
		curColor = newColor;
		light.color = colors[curColor];
	}

	if (!trainMoving)
		trainCooldown += 1;

	if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8 && !trainSound.playing)
	{
		trainCooldown = FlxG.random.int(-4, 0);
		trainStart();
	}
}

function update(elapsed:Float) {
	if (Conductor.songPosition > 0)
		light.alpha = 1 - (FlxEase.cubeIn((curBeatFloat / 4) % 1) * 0.85);
	else
		light.alpha = 0;

	if (trainMoving) {
		updateTrainPos();
	}
}

function trainStart():Void
{
	trainMoving = true;
	if (!trainSound.playing)
		trainSound.play(true);
}

var startedMoving:Bool = false;

function updateTrainPos():Void
{
	if (trainSound.time >= 4700)
	{
		startedMoving = true;
		gf.playAnim('hairBlow');
	}

	if (startedMoving)
	{
		phillyTrain.velocity.x = -400 * 24;
		if (phillyTrain.x < -2000 && !trainFinishing)
		{
			phillyTrain.x = -1150;
			trainCars -= 1;

			if (trainCars <= 0)
				trainFinishing = true;
		}

		if (phillyTrain.x < -4000 && trainFinishing)
			trainReset();
	}
}

function trainReset():Void
{
	gf.playAnim('hairFall', true);
	phillyTrain.x = FlxG.width + 200;
	trainMoving = false;
	// trainSound.stop();
	// trainSound.time = 0;
	trainCars = 8;
	trainFinishing = false;
	startedMoving = false;
	phillyTrain.velocity.x = 0;
}