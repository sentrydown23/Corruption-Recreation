function postHide() {
	if(curTween != null) {
		var anim = getAnimName();
		// If either entry animation is playing, cancel the fade-out so alpha stays 1!
		if(anim == 'angry-show' || anim == 'eyeless-show') curTween.cancel();
		else curTween.percent = 1;
	}
}