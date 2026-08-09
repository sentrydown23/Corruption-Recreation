var TextD1:FlxSprite;
var TextD1_2:FlxSprite;
var TextD2:FlxSprite;
var TextD2_1:FlxSprite;
var TextD3:FlxSprite;
var TextD3_2:FlxSprite;
var TextD4:FlxSprite;
var TextD4_2:FlxSprite;
var TextD5:FlxSprite;
var TextD5_2:FlxSprite;
var TextD6:FlxSprite;
var TextD6_1:FlxSprite;
var TextD6_2:FlxSprite;
var TextD7:FlxSprite;
var TextD8:FlxSprite;
var TextD9:FlxSprite;
var TextD9_1:FlxSprite;
var TextD9_2:FlxSprite;
var TextD10:FlxSprite;
var TextD10_2:FlxSprite;
var TextD11:FlxSprite;
var TextD12:FlxSprite;
var TextD13:FlxSprite;
var TextD14:FlxSprite;
var TextD14_2:FlxSprite;
var TextD15:FlxSprite;
var TextD16:FlxSprite;
var TextD17:FlxSprite;
var TextD18:FlxSprite;
var TextD19:FlxSprite;
var TextD20:FlxSprite;
var TextD21:FlxSprite;
var TextD22:FlxSprite;
var TextD23:FlxSprite;
var TextD24:FlxSprite;
var TextD25:FlxSprite;
var TextD26:FlxSprite;
var TextD27:FlxSprite;
var TextD28:FlxSprite;
var TextD29:FlxSprite;
var TextD29_2:FlxSprite;
var TextD30:FlxSprite;
var TextD31:FlxSprite;
var TextD31_1:FlxSprite;
var TextD32:FlxSprite;
var TextD33:FlxSprite;
var TextD34:FlxSprite;
var TextD35:FlxSprite;
var TextD36:FlxSprite;
var TextD37:FlxSprite;

function createTextSprite(path:String):FlxSprite {
    var spr:FlxSprite = new FlxSprite(0, 0);
    spr.loadGraphic(Paths.image("stages/screen/discharge/dialogue/" + path));
    spr.alpha = 0.001;
    spr.cameras = [camHUD];
    add(spr);
    return spr;
}

function postCreate() {
    TextD1 = createTextSprite("TextD1");
    TextD1_2 = createTextSprite("TextD1_2");
    TextD2 = createTextSprite("TextD2");
    TextD2_1 = createTextSprite("TextD2_1");
    TextD3 = createTextSprite("TextD3");
    TextD3_2 = createTextSprite("TextD3_2");
    TextD4 = createTextSprite("TextD4");
    TextD4_2 = createTextSprite("TextD4_2");
    TextD5 = createTextSprite("TextD5");
    TextD5_2 = createTextSprite("TextD5_2");
    TextD6 = createTextSprite("TextD6");
    TextD6_1 = createTextSprite("TextD6_1");
    TextD6_2 = createTextSprite("TextD6_2");
    TextD7 = createTextSprite("TextD7");
    TextD8 = createTextSprite("TextD8");
    TextD9 = createTextSprite("TextD9");
    TextD9_1 = createTextSprite("TextD9_1");
    TextD9_2 = createTextSprite("TextD9_2");
    TextD10 = createTextSprite("TextD10");
    TextD10_2 = createTextSprite("TextD10_2");
    TextD11 = createTextSprite("TextD11");
    TextD12 = createTextSprite("TextD12");
    TextD13 = createTextSprite("TextD13");
    TextD14 = createTextSprite("TextD14");
    TextD14_2 = createTextSprite("TextD14_2");
    TextD15 = createTextSprite("TextD15");
    TextD16 = createTextSprite("TextD16");
    TextD17 = createTextSprite("TextD17");
    TextD18 = createTextSprite("TextD18");
    TextD19 = createTextSprite("TextD19");
    TextD20 = createTextSprite("TextD20");
    TextD21 = createTextSprite("TextD21");
    TextD22 = createTextSprite("TextD22");
    TextD23 = createTextSprite("TextD23");
    TextD24 = createTextSprite("TextD24");
    TextD25 = createTextSprite("TextD25");
    TextD26 = createTextSprite("TextD26");
    TextD27 = createTextSprite("TextD27");
    TextD28 = createTextSprite("TextD28");
    TextD29 = createTextSprite("TextD29");
    TextD29_2 = createTextSprite("TextD29_2");
    TextD30 = createTextSprite("TextD30");
    TextD31 = createTextSprite("TextD31");
    TextD31_1 = createTextSprite("TextD31_1");
    TextD32 = createTextSprite("TextD32");
    TextD33 = createTextSprite("TextD33");
    TextD34 = createTextSprite("TextD34");
    TextD35 = createTextSprite("TextD35");
    TextD36 = createTextSprite("TextD36");
    TextD37 = createTextSprite("TextD37");
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 16:
            FlxTween.tween(TextD1, {alpha: 1}, 0.5);

        case 28:
            FlxTween.tween(TextD1, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD1_2, {alpha: 1}, 0.001);

        case 40:
            FlxTween.tween(TextD1_2, {alpha: 0.001}, 1);

        case 67:
            FlxTween.tween(TextD2, {alpha: 1}, 0.5);
            remove(TextD1, true);
            remove(TextD1_2, true);

        case 80:
            FlxTween.tween(TextD2_1, {alpha: 1}, 0.001);
            FlxTween.tween(TextD2, {alpha: 0.001}, 0.001);

        case 84:
            FlxTween.tween(TextD2_1, {alpha: 0}, 0.001);
            FlxTween.tween(TextD2, {alpha: 1}, 0.001);

        case 86:
            FlxTween.tween(TextD2, {alpha: 0.001}, 0.5);

        case 112:
            FlxTween.tween(TextD3, {alpha: 1}, 0.5);
            remove(TextD2, true);
            remove(TextD2_1, true);

        case 122:
            FlxTween.tween(TextD3, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD3_2, {alpha: 1}, 0.001);

        case 132:
            FlxTween.tween(TextD3_2, {alpha: 0.001}, 0.5);

        case 160:
            FlxTween.tween(TextD4, {alpha: 1}, 1);
            remove(TextD3, true);
            remove(TextD3_2, true);

        case 172:
            FlxTween.tween(TextD4, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD4_2, {alpha: 1}, 0.001);

        case 176:
            FlxTween.tween(TextD4, {alpha: 1}, 0.001);
            FlxTween.tween(TextD4_2, {alpha: 0.001}, 0.001);

        case 178:
            FlxTween.tween(TextD4, {alpha: 0.001}, 0.5);

        case 208:
            FlxTween.tween(TextD5, {alpha: 1}, 0.5);
            remove(TextD4, true);
            remove(TextD4_2, true);

        case 222:
            FlxTween.tween(TextD5, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD5_2, {alpha: 1}, 0.001);

        case 228:
            FlxTween.tween(TextD5_2, {alpha: 0.001}, 0.5);

        case 256:
            FlxTween.tween(TextD6, {alpha: 1}, 0.5);
            remove(TextD5, true);
            remove(TextD5_2, true);

        case 268:
            FlxTween.tween(TextD6, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD6_2, {alpha: 1}, 0.001);

        case 270:
            FlxTween.tween(TextD6_2, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD6_1, {alpha: 1}, 0.001);

        case 274:
            FlxTween.tween(TextD6_1, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD6, {alpha: 1}, 0.001);

        case 276:
            FlxTween.tween(TextD6, {alpha: 0.001}, 0.5);

        case 304:
            FlxTween.tween(TextD7, {alpha: 1}, 0.5);
            remove(TextD6, true);
            remove(TextD6_1, true);
            remove(TextD6_2, true);

        case 334:
            FlxTween.tween(TextD7, {alpha: 0.001}, 0.5);

        case 426:
            FlxTween.tween(TextD8, {alpha: 1}, 0.5);
            remove(TextD7, true);

        case 448:
            FlxTween.tween(TextD8, {alpha: 0.001}, 0.5);

        case 536:
            FlxTween.tween(TextD9, {alpha: 1}, 0.5);
            remove(TextD8, true);

        case 542:
            FlxTween.tween(TextD9, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD9_2, {alpha: 1}, 0.001);

        case 543:
            FlxTween.tween(TextD9, {alpha: 1}, 0.001);
            FlxTween.tween(TextD9_2, {alpha: 0.001}, 0.001);

        case 550:
            FlxTween.tween(TextD9, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD9_1, {alpha: 1}, 0.001);

        case 554:
            FlxTween.tween(TextD9, {alpha: 1}, 0.001);
            FlxTween.tween(TextD9_1, {alpha: 0.001}, 0.001);

        case 560:
            FlxTween.tween(TextD9, {alpha: 0.001}, 0.5);

        case 728:
            FlxTween.tween(TextD10, {alpha: 1}, 0.5);
            remove(TextD9, true);
            remove(TextD9_1, true);
            remove(TextD9_2, true);

        case 736:
            FlxTween.tween(TextD10, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD10_2, {alpha: 1}, 0.001);

        case 744:
            FlxTween.tween(TextD10_2, {alpha: 0.001}, 0.5);

        case 830:
            FlxTween.tween(TextD11, {alpha: 1}, 0.5);
            remove(TextD10, true);
            remove(TextD10_2, true);

        case 840:
            FlxTween.tween(TextD11, {alpha: 0.001}, 0.01);

        case 853:
            FlxTween.tween(TextD12, {alpha: 1}, 0.5);
            remove(TextD11, true);

        case 866:
            FlxTween.tween(TextD12, {alpha: 0.001}, 0.01);

        case 877:
            FlxTween.tween(TextD13, {alpha: 1}, 0.5);
            remove(TextD12, true);

        case 887:
            FlxTween.tween(TextD13, {alpha: 0.001}, 0.01);

        case 900:
            FlxTween.tween(TextD14, {alpha: 1}, 0.5);
            remove(TextD13, true);

        case 906:
            FlxTween.tween(TextD14, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD14_2, {alpha: 1}, 0.001);

        case 916:
            FlxTween.tween(TextD14, {alpha: 1}, 0.001);
            FlxTween.tween(TextD14_2, {alpha: 0.001}, 0.001);

        case 920:
            FlxTween.tween(TextD14, {alpha: 0.001}, 0.01);
            remove(TextD14, true);
            remove(TextD14_2, true);

        case 1408:
            FlxTween.tween(TextD15, {alpha: 1}, 0.25);

        case 1412:
            FlxTween.tween(TextD15, {alpha: 0.001}, 0.25);

        case 1663:
            FlxTween.tween(TextD16, {alpha: 1}, 0.2);
            remove(TextD15, true);

        case 1666:
            FlxTween.tween(TextD16, {alpha: 0.001}, 0.2);

        case 1774:
            FlxTween.tween(TextD17, {alpha: 1}, 0.2);
            remove(TextD16, true);

        case 1783:
            FlxTween.tween(TextD17, {alpha: 0.001}, 0.2);

        case 2044:
            FlxTween.tween(TextD18, {alpha: 1}, 0.2);
            remove(TextD17, true);

        case 2048:
            FlxTween.tween(TextD18, {alpha: 0.001}, 0.2);

        case 2524:
            FlxTween.tween(TextD19, {alpha: 1}, 0.5);
            remove(TextD18, true);

        case 2538:
            FlxTween.tween(TextD19, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD20, {alpha: 1}, 0.001);

        case 2540:
            FlxTween.tween(TextD20, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD19, {alpha: 1}, 0.001);

        case 2546:
            FlxTween.tween(TextD19, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD21, {alpha: 1}, 0.001);

        case 2548:
            FlxTween.tween(TextD21, {alpha: 0.001}, 0.5);

        case 2592:
            FlxTween.tween(TextD22, {alpha: 1}, 0.5);
            remove(TextD20, true);
            remove(TextD21, true);
            remove(TextD19, true);

        case 2603:
            FlxTween.tween(TextD22, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD23, {alpha: 1}, 0.001);

        case 2608:
            FlxTween.tween(TextD23, {alpha: 0.001}, 0.5);

        case 2681:
            FlxTween.tween(TextD24, {alpha: 1}, 0.5);
            remove(TextD22, true);
            remove(TextD23, true);

        case 2688:
            FlxTween.tween(TextD24, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD25, {alpha: 1}, 0.001);

        case 2698:
            FlxTween.tween(TextD25, {alpha: 0.001}, 0.5);

        case 2752:
            FlxTween.tween(TextD26, {alpha: 1}, 0.2);
            remove(TextD24, true);
            remove(TextD25, true);

        case 2758:
            FlxTween.tween(TextD26, {alpha: 0.001}, 0.2);

        case 2810:
            FlxTween.tween(TextD27, {alpha: 1}, 0.2);
            remove(TextD26, true);

        case 2816:
            FlxTween.tween(TextD27, {alpha: 0.001}, 0.2);

        case 2880:
            FlxTween.tween(TextD28, {alpha: 1}, 0.2);
            remove(TextD27, true);

        case 2886:
            FlxTween.tween(TextD28, {alpha: 0.001}, 0.2);

        case 2910:
            FlxTween.tween(TextD29, {alpha: 1}, 0.5);
            remove(TextD28, true);

        case 2924:
            FlxTween.tween(TextD29, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD29_2, {alpha: 1}, 0.001);

        case 2926:
            FlxTween.tween(TextD29_2, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD30, {alpha: 1}, 0.001);

        case 2936:
            FlxTween.tween(TextD30, {alpha: 0.001}, 0.5);
            remove(TextD29_2, true);
            remove(TextD29, true);

        case 3198:
            FlxTween.tween(TextD31, {alpha: 1}, 0.5);
            remove(TextD30, true);

        case 3210:
            FlxTween.tween(TextD31, {alpha: 0.001}, 0.001);
            FlxTween.tween(TextD31_1, {alpha: 1}, 0.001);

        case 3214:
            FlxTween.tween(TextD31_1, {alpha: 0.001}, 0.5);

        case 3446:
            FlxTween.tween(TextD32, {alpha: 1}, 0.2);
            remove(TextD31, true);
            remove(TextD31_1, true);

        case 3456:
            FlxTween.tween(TextD32, {alpha: 0.001}, 0.2);

        case 3488:
            FlxTween.tween(TextD33, {alpha: 1}, 0.2);
            remove(TextD32, true);

        case 3494:
            FlxTween.tween(TextD33, {alpha: 0.001}, 0.2);

        case 3547:
            FlxTween.tween(TextD34, {alpha: 1}, 0.2);
            remove(TextD33, true);

        case 3550:
            FlxTween.tween(TextD34, {alpha: 0}, 0.2);

        case 3804:
            FlxTween.tween(TextD35, {alpha: 1}, 0.2);
            remove(TextD34, true);

        case 3818:
            FlxTween.tween(TextD35, {alpha: 0.001}, 0.2);

        case 4018:
            FlxTween.tween(TextD36, {alpha: 1}, 0.2);
            remove(TextD35, true);

        case 4028:
            FlxTween.tween(TextD36, {alpha: 0.001}, 0.2);
    }
}