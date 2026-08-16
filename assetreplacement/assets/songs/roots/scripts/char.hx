import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var player = strumLines.members[1].characters;
var opponent = strumLines.members[0].characters;

// Toggle & Configuration Variables
var enableFloat:Bool = false;
var circleRadius:Float = 35.0; // How far they move in the circle

// Speed bounds for randomization
var minSpeed:Float = 3.5;
var maxSpeed:Float = 4.5;

// Individual speeds and timers for unsynced motion
var playerSpeed:Float = 2.0;
var opponentSpeed:Float = 2.0;
var playerTimer:Float = 0;
var opponentTimer:Float = 0;

// Ramping intensity variable for instant spin-up
var floatIntensity:Float = 0.0;
var rampTween:FlxTween = null;

// Store original positions
var playerBaseX:Float = 0;
var playerBaseY:Float = 0;
var opponentBaseX:Float = 0;
var opponentBaseY:Float = 0;

// Internal state tracking
var wasFloating:Bool = false;

var playerTween:FlxTween = null;
var opponentTween:FlxTween = null;

function postCreate()
{
	offsetBF();

	// Grab original base positions after offsets are applied
	if (player[0] != null) {
		playerBaseX = player[0].x;
		playerBaseY = player[0].y;
	}
	if (opponent[0] != null) {
		opponentBaseX = opponent[0].x;
		opponentBaseY = opponent[0].y;
	}
}

function beatHit(_)
{
	switch(_)
	{
		case 128:
			enableFloat = true;

        case 160:
            enableFloat = false;

        case 224:
            enableFloat = true;

        case 352:
            enableFloat = false;
	}
}

function offsetBF()
{
	if (player[0] != null)
		player[0].y -= 90;
}

function randomizeSpeeds()
{
	playerSpeed = FlxG.random.float(minSpeed, maxSpeed);
	opponentSpeed = FlxG.random.float(minSpeed, maxSpeed);
	
	// Randomize starting phase angle so they don't start at the same point in the circle
	playerTimer = FlxG.random.float(0, Math.PI * 2);
	opponentTimer = FlxG.random.float(0, Math.PI * 2);
}

function update(elapsed:Float)
{
	if (enableFloat)
	{
		if (!wasFloating)
		{
			randomizeSpeeds();
			if (playerTween != null) playerTween.cancel();
			if (opponentTween != null) opponentTween.cancel();
			if (rampTween != null) rampTween.cancel();

			floatIntensity = 0.0;
			
			// Changed ease to quadOut for an instant start that smoothly caps off at 1.0 speed
			rampTween = FlxTween.num(0.0, 1.0, 0.6, {ease: FlxEase.quadOut}, function(val:Float) {
				floatIntensity = val;
			});

			wasFloating = true;
		}

		// Advance timers independently (scaled by floatIntensity)
		playerTimer += elapsed * playerSpeed * floatIntensity;
		opponentTimer += elapsed * opponentSpeed * floatIntensity;

		// Calculate active scaled radius
		var currentRadius:Float = circleRadius * floatIntensity;

		// Orbit player
		if (player[0] != null) {
			player[0].x = playerBaseX + (Math.cos(playerTimer) * currentRadius);
			player[0].y = playerBaseY + (Math.sin(playerTimer) * currentRadius);
		}

		// Orbit opponent
		if (opponent[0] != null) {
			opponent[0].x = opponentBaseX + (Math.cos(opponentTimer) * currentRadius);
			opponent[0].y = opponentBaseY + (Math.sin(opponentTimer) * currentRadius);
		}
	}
	else if (wasFloating)
	{
		// Floating disabled; cancel ramp tween and tween both back to base positions
		wasFloating = false;
		if (rampTween != null) rampTween.cancel();
		floatIntensity = 0.0;

		if (player[0] != null) {
			playerTween = FlxTween.tween(player[0], {x: playerBaseX, y: playerBaseY}, 0.6, {
				ease: FlxEase.sineOut
			});
		}

		if (opponent[0] != null) {
			opponentTween = FlxTween.tween(opponent[0], {x: opponentBaseX, y: opponentBaseY}, 0.6, {
				ease: FlxEase.sineOut
			});
		}
	}
}