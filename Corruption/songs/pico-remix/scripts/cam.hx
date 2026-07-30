function postCreate() {
    defaultDisplayRating = false;
    defaultDisplayCombo = false;
    minDigitDisplay = -1;
    startSong();
}

function onCountdown(event) {
   event.cancel();
}