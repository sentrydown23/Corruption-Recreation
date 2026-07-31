var player = strumLines.members[1].characters;
var opponent = strumLines.members[0].characters;
var middle = strumLines.members[2].characters;

function postCreate()
{
    player[1].visible = false;
    opponent[1].visible = false;    
    middle[1].visible = false;
}

function beatHit(_) 
{
    switch(_)
    {
        case 86:
            player[1].visible = true;
            player[0].visible = false;
            opponent[1].visible = true;
            opponent[0].visible = false;
            middle[1].visible = true;
            middle[0].visible = false;

        case 96:
            middle[1].visible = false;
            middle[0].visible = true; 

        case 110:
			middle[1].visible = true;
            middle[0].visible = false;

		case 112:
			middle[1].visible = false;
            middle[0].visible = true; 

        case 152:
            middle[0].visible = false;
            middle[1].visible = true;
    }
}