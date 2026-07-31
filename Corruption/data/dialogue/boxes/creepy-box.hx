var spirit:FlxSprite;

function postCreate() {
	FlxG.camera._fxFadeAlpha = 0;
}


var finished:Bool = false;
function close(event) {
	if(finished) return;
	else event.cancelled = true;
	cutscene.canProceed = false;

	cutscene.curMusic?.fadeOut(1, 0);
	for(c in cutscene.charMap) c.visible = false;

	if (spirit != null) {
		spirit.destroy();
	}

	new FlxTimer().start(0.4, function(swagTimer:FlxTimer) {
		cutscene.dialogueCamera.alpha -= 0.15;

		if(cutscene.dialogueCamera.alpha > 0) swagTimer.reset();
		else {
			finished = true;
			cutscene.close();
		}
	});
}

function popupChar(event) {
	if(!active || event.char.positionName != "left") return;
	event.char.color = FlxColor.BLACK;
}