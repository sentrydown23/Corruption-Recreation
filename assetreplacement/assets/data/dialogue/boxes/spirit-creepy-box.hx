import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxG;

// Declare at the top level so it persists properly in HScript scope
var spirit:FlxSprite;
var spirit2:FlxSprite;

function postCreate() {
	spirit = new FlxSprite(320, 170).loadGraphic(Paths.image('game/cutscenes/weeb/spiritFaceForward'));
	spirit.setGraphicSize(Std.int(spirit.width * 6));
	cutscene.add(spirit);

	spirit2 = new FlxSprite(320, 170).loadGraphic(Paths.image('pixelui/spiritFaceForwardScary'));
	spirit2.setGraphicSize(Std.int(spirit2.width * 6));
	cutscene.add(spirit2);

	spirit2.visible = false;

	FlxG.camera._fxFadeAlpha = 0;
	cutscene.dialogueCamera.bgColor = FlxColor.fromRGBFloat(1, 1, 1, 0.3);
}

function startText(event) {
	var currentText:String = "";

	if (event != null && event.line != null) {
		// Extract raw text string safely whether it's a String or Text object
		if (Std.isOfType(event.line.text, String)) {
			currentText = event.line.text;
		} else if (event.line.text != null && Reflect.hasField(event.line.text, "text")) {
			currentText = event.line.text.text;
		} else if (Reflect.hasField(event.line, "rawText")) {
			currentText = event.line.rawText;
		}
	} else if (cutscene != null && cutscene.curLine != null) {
		currentText = cutscene.curLine.text;
	}

	if (StringTools.trim(currentText) == "I am going to KILL you myself.") {
		spirit2.visible = true;
		spirit.visible = false;
	}

	// StringTools.trim handles any trailing spaces/newlines from the XML
	if (StringTools.trim(currentText) == "I understand now.") {
		spirit.visible = true;
		spirit2.visible = false;
	}

	if (StringTools.trim(currentText) == "I will be taking you down with me.") {
		spirit2.visible = true;
		spirit.visible = false;
	}
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
