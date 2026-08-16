import openfl.display.BlendMode;

var startBreaks:Array<FlxSprite> = [];
var platforms:Array<FlxSprite> = [];
var firstBGParts:Array<FlxSprite> = [];
var secondBGParts:Array<FlxSprite> = [];
var transitions:Array<FlxSprite> = [];

function create()
{
	startBreaks.push(Glass);
	startBreaks.push(Explosion);

	platforms.push(platform1);
	platforms.push(platform2);

	firstBGParts.push(bg1); // 0
	firstBGParts.push(ground1); // 1
	firstBGParts.push(sunshine); // 2
	firstBGParts.push(sun); // 3
	firstBGParts.push(bgWater); // 4
	firstBGParts.push(ground2); // 4

	transitions.push(transW);
	transitions.push(transW2);

	secondBGParts.push(bg2);
	secondBGParts.push(cs2);
	secondBGParts.push(sunshine);
	secondBGParts.push(star1);
	secondBGParts.push(star2);
	secondBGParts.push(star3);
}

function postCreate()
{
	for (spr in startBreaks) {
		spr.x -= 150;
		spr.y -= 100;
	}

	for (spr in firstBGParts) {
		spr.alpha = 0;
	}

	for (spr in secondBGParts) {
		spr.alpha = 0;
	}

	platforms[1].alpha = 0;

	for (group in [firstBGParts, transitions, secondBGParts]) {
        for (spr in group) {
            spr.x += 300;
        }
    }

	secondBGParts[3].x += 600;
	secondBGParts[4].x += 600;
	secondBGParts[5].x += 600;

	transitions[0].x += 300;
	transitions[1].alpha = 0;
	// firstBGParts[4].blend = BlendMode.MULTIPLY;
}

function stepHit(curStep:Int)
{
	switch(curStep)
	{
		case 25:
			startBreaks[0].playAnim('Break', true, false);
			startBreaks[1].playAnim('Boom', true, false);

		case 43:
			FlxTween.tween(startBreaks[0], {alpha: 0}, 2.5, {ease: FlxEase.quadIn});
			FlxTween.tween(startBreaks[1], {alpha: 0}, 2.5, {ease: FlxEase.quadIn});

		case 401:
			for (spr in platforms) {
				FlxTween.tween(spr, {y: -4090}, 0.2, {ease: FlxEase.expoIn});
			}

		case 763:
			FlxTween.tween(transitions[0], {y: transitions[0].y + 10950}, 1.5, {ease: FlxEase.linear});

		case 770:
			for (spr in firstBGParts) {
				spr.alpha = 1;
			}
			platforms[1].alpha = 1;
			platforms[0].alpha = 0;
			firstBGParts[2].alpha = 0;
			firstBGParts[4].alpha = 0.4;
			firstBGParts[4].playAnim('Water', true, true);
			FlxTween.tween(firstBGParts[0], {y: firstBGParts[0].y + 860}, 68, {ease: FlxEase.linear});
			FlxTween.tween(firstBGParts[4], {y: firstBGParts[4].y + 840}, 68, {ease: FlxEase.linear});
			FlxTween.tween(firstBGParts[1], {y: firstBGParts[1].y + 837}, 68, {ease: FlxEase.linear});
			FlxTween.tween(firstBGParts[5], {y: firstBGParts[5].y + 675}, 68, {ease: FlxEase.linear});
            FlxTween.tween(firstBGParts[3], {y: firstBGParts[3].y + 525}, 68, {ease: FlxEase.linear});

		case 1657:
			transitions[1].alpha = 1;
			FlxTween.tween(transitions[1], {y: transitions[1].y + 13000}, 2, {ease: FlxEase.linear});

		case 1677:
			for (spr in secondBGParts) {
				spr.alpha = 1;
			}
			for (spr in firstBGParts) {
				spr.alpha = 0;
			}
			for (spr in platforms) {
				spr.alpha = 0;
			}


		case 1680:
            FlxTween.tween(secondBGParts[3], {alpha: 1}, 0.2);
			FlxTween.tween(secondBGParts[4], {alpha: 1}, 0.2);
			FlxTween.tween(secondBGParts[5], {alpha: 1}, 0.2);

            FlxTween.tween(secondBGParts[0], {y: secondBGParts[0].y + 180}, 1.5, {ease: FlxEase.quadOut});
            FlxTween.tween(secondBGParts[1], {y: secondBGParts[1].y + 560}, 1.5, {ease: FlxEase.quadOut});
            FlxTween.tween(secondBGParts[3], {y: secondBGParts[3].y + 1050}, 43, {ease: FlxEase.linear});
            FlxTween.tween(secondBGParts[4], {y: secondBGParts[4].y + 1500}, 43, {ease: FlxEase.linear});
            FlxTween.tween(secondBGParts[5], {y: secondBGParts[5].y + 800}, 43, {ease: FlxEase.linear});

		case 1922:
			FlxTween.tween(secondBGParts[4], {alpha: 0}, 1.25, {ease: FlxEase.linear});

		case 2014:
			FlxTween.tween(secondBGParts[3], {alpha: 0}, 1, {ease: FlxEase.linear});

		case 2208:
			FlxTween.tween(secondBGParts[5], {alpha: 0}, 4, {ease: FlxEase.linear});
	}
}