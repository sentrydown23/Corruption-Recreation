import flixel.addons.effects.FlxTrail;

var self = this;
var trail:FlxTrail;

function postCreate() {
	trail = new FlxTrail(self, null, 4, 24, 0.3, 0.069);
	// Initial visibility sync
	trail.visible = self.visible;
	trail.active = self.visible;
}

var toAdd:Bool = true;

function update(elapsed) {
	// Insert trail into PlayState depth hierarchy on the first frame
	if(toAdd) {
		toAdd = false;
		PlayState.instance.insert(PlayState.instance.members.indexOf(self), trail);
	}

	// Continuously sync trail visibility and activity with the character
	if (trail != null) {
		trail.visible = self.visible;
		trail.active = self.visible;
	}
}