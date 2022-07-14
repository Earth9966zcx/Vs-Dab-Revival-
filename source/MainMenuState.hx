package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if newgrounds
import io.newgrounds.NG;
#end
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;
	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.3" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var camFollow:FlxObject;
	var blackbars:FlxSprite;
	var blackbars2:FlxSprite;
	var charS:FlxSprite;
	var charF:FlxSprite;
	var charD:FlxSprite;
	var charO:FlxSprite;
	var sus:Bool = false;
	

	public static var finishedFunnyMove:Bool = false;
	

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

    
    
		var bg:FlxSprite = new FlxSprite(0, 0);
		bg.loadGraphic(Paths.image('menushits/BG'));
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		
    var blackbars:FlxSprite = new FlxSprite(0, -500);
    blackbars.loadGraphic(Paths.image('menushits/titleoutline1'));
		blackbars.scrollFactor.set();
		blackbars.updateHitbox();
		blackbars.screenCenter(X);
    add(blackbars);
    
    var blackbars2:FlxSprite = new FlxSprite(0, 500);
    blackbars2.loadGraphic(Paths.image('menushits/titleoutline2'));
		blackbars2.scrollFactor.set();
		blackbars2.updateHitbox();
		blackbars2.screenCenter(X);
    add(blackbars2);
    
    var charS:FlxSprite = new FlxSprite(0, 0);
    charS.loadGraphic(Paths.image('menushits/menuArts/menuStorymode'));
		charS.scrollFactor.set();
		charS.updateHitbox();
		charS.visible = false;
    add(charS);
    
    var charF:FlxSprite = new FlxSprite(0, 0);
    charF.loadGraphic(Paths.image('menushits/menuArts/menuFreeplay'));
		charF.scrollFactor.set();
		charF.updateHitbox();
		charF.visible = false;
    add(charF);
    
    if (curSelected == 0) {
		charS.visible = true;
		charF.visible = false;
    }
		if (curSelected == 1) {
		charS.visible = false;
		charF.visible = true;
		}
		if (curSelected == 2) {
		//nothing lmao
		}
		if (curSelected == 3) {
		//nothing lmao
		}
    

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItem.x += 700;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.scale.set(0.8, 0.8);
			menuItem.antialiasing = true;
			if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween)
				   {
						finishedFunnyMove = true; 
						changeItem();
  				}});
			else
				menuItem.y = 60 + (i * 160);
		}
		
		  if (firstStart) {
		  	FlxTween.tween(blackbars2, {y: 0}, 1, {ease: FlxEase.expoInOut});
				FlxTween.tween(blackbars, {y: 0}, 1, {ease: FlxEase.expoInOut});
				{
				  sus = true;
				}}
		  else
        blackbars.x += 0;
        blackbars2.x += 0;
  {

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();
		
		#if android
		addVirtualPad(UP_DOWN, A_B);
		#end
		
		
	var selectedSomethin:Bool = false;


	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					fancyOpenURL("https://ninja-muffin24.itch.io/funkin");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
              FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}
	}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

			
	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
