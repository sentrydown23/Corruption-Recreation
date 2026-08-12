var normalBG:Array<FlxSprite> = [];
var spookyBG:Array<FlxSprite> = [];

var evilSpooky:Bool = false;

function postCreate() 
{
	normalBG = [bgSky1, fgTrees1, bgTrees, bgStreet1, bgSchool1, treeLeaves1];
	spookyBG = [bgSky2, fgTrees2, bgStreet2, bgSchool2, treeLeaves2];

	for (spr in normalBG) spr.alpha = 1;
	for (spr in spookyBG) spr.alpha = 0;
}

function stepHit(curStep:Int) // Using stepHit for precision 
{
	switch(curStep)
	{
		case 279, 280, 281, 282, 283, 285, 286, 289, 311, 312, 313, 314, 315, 316, 318:
			evilSpookyStage();
		
		case 321, 393, 401, 445, 449, 513, 515, 516, 518, 519, 521, 541, 545, 657, 669, 779, 780:
			evilSpookyStage();

		case 780, 781, 785, 803, 804, 805, 809, 897, 898, 899, 900, 901, 902, 903, 904, 905, 906:
			evilSpookyStage();

		case 963, 977, 988, 993, 1041, 1049, 1050, 1053, 1054, 1055, 1056, 1057, 1079, 1087, 1088, 1089:
			evilSpookyStage();	
	}
}

function evilSpookyStage() 
{
	evilSpooky = !evilSpooky;

	for (spr in normalBG) spr.alpha = evilSpooky ? 0 : 1;
	for (spr in spookyBG) spr.alpha = evilSpooky ? 1 : 0;
}