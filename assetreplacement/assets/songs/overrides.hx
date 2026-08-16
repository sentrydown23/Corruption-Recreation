// doIconBop = false;
// defaultDisplayRating = false;
// defaultDisplayCombo = false;
// minDigitDisplay = -1;

var gameoverState = GameOverSubstate;
var pauseState = PauseSubState;

function postCreate() {

    switch(SONG.meta.name)
    {
        case "frostbite", "tormentor", "neuroses", "discharge", "memoryleak", "senpai-remix", "dead-pixel", "treacherous-thorns", "roots":

        default:
            gameoverState.script = "data/scripts/gameover-normal";
    }   
}