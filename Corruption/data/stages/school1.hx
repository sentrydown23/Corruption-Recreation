var normalBG:Array<FlxSprite> = [];
var glitchBG:Array<FlxSprite> = [];

function postCreate() 
{
	normalBG = [bgGirls1, bgSky1, bgTrees1, fgTrees1, bgStreet1, bgSchool1];
	glitchBG = [bgGirls2, bgSky2, bgTrees2, fgTrees2, bgStreet2, bgSchool2];

	bgBack();
}

function beatHit(curBeat:Int)
{
	switch(curBeat)
	{
		case 86, 110, 152:
			bgGlitch();

		case 96, 112:
			bgBack();
	}
}

function setGlitchState(isGlitched:Bool)
{
	for (spr in normalBG) spr.alpha = isGlitched ? 0 : 1;
	for (spr in glitchBG) spr.alpha = isGlitched ? 1 : 0;
}

function bgGlitch() setGlitchState(true);
function bgBack()   setGlitchState(false);