var song = SONG.meta.name;

function create() {
    switch(song) {
        case "senpai-remix", "dead-pixel", "treacherous-thorns", "roots":
            introSounds = ["intro3-pixel", "intro2-pixel", "intro1-pixel", "introGo-pixel"];

        case "discharge":
            introSounds = ["intro3-discharge", "intro2-discharge", "intro1-discharge", "introGo-discharge"];

        default: 
            introSounds = ["intro3-creep", "intro2-creep", "intro1-creep", "introGo-creep"];
    }
}

function onCountdown(event) {
    switch(song) {
        case "memoryleak":
            event.cancel();

        case "senpai-remix", "dead-pixel", "treacherous-thorns", "roots":
            //handled by data/scripts/pixel.hx

        default:
    	    event.spritePath = switch(event.swagCounter) {
		    case 0: null;
		    case 1: 'ratings/creep/ready';
		    case 2: 'ratings/creep/set';
		    case 3: 'ratings/creep/go';
        }
    }
}

function onPlayerHit(event) {
    switch(song) {
        case "senpai-remix", "dead-pixel", "treacherous-thorns", "roots":
            // handled by data/scripts/pixel.hx

        case "memoryleak":
            // Doing nothing

        default:
            event.ratingPrefix = "ratings/creep/";
    }
}