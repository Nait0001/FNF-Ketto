package states.stages;

import openfl.filters.ShaderFilter;
import openfl.filters.BlurFilter;
import states.stages.objects.*;

class Kitchen extends BaseStage
{
	// If you're moving your stage from PlayState to a stage file,
	// you might have to rename some variables if they're missing, for example: camZooming -> game.camZooming

	var blackScreen:FlxSprite;
	var vhs:BGSprite;
	// var cameraSD:Float;
	override function create()
	{
		var kitchen:BGSprite = new BGSprite('kitchen/bg');
		add(kitchen);

		PlayState.instance.addCinematicBar();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		blackScreen.cameras = [camOther];
		add(blackScreen);

		var scaleVHS:Float = 1.7;
		vhs = new BGSprite('vhs', 0, 0, 1, 1, ["giphy_gif00"], true);
		vhs.setGraphicSize(Std.int(FlxG.width * scaleVHS),FlxG.height);
		vhs.screenCenter();
		vhs.x -= 250;
		vhs.cameras = [camHUD];
		vhs.alpha = 0.5;
		add(vhs);
		vhs.dance(true);

		// Spawn your stage sprites here.
		// Characters are not ready yet on this function, so you can't add things above them yet.
		// Use createPost() if that's what you want to do.
	}
	
	var startCamZoom:Float;
	var sprFrameGroup:FlxSpriteGroup = null;
	var shader:shaders.VCRDistortionEffect;
	var creditText:FlxText;
	var blcFinal:FlxSprite;
	// var cameraLogo:FlxCamera = new FlxCamera();
	override function createPost()
	{
		// Use this function to layer things above characters!

		var light:BGSprite = new BGSprite('kitchen/light');
		add(light);

		shader = new shaders.VCRDistortionEffect();
		shader.setCurvate(false);
		shader.setDistortion(false);
		// shader.setGlitchModifier(2);
		// shader.setGlitchModifier(-0.);
		camGame.setFilters([new ShaderFilter(shader.shader)]);

		// cameraSD = PlayState.instance.cameraSpeed;
		PlayState.instance.cameraSpeed = 99999999;
		PlayState.instance.camZoomingDecay = 99999999;

		// camZoomingDecay
		startCamZoom = defaultCamZoom;
		PlayState.instance.skipCountdown = true;
		PlayState.instance.camZooming = true;
		
		blcFinal = new FlxSprite().makeGraphic(Std.int(FlxG.width*2),Std.int(FlxG.height*2),0xFF404040);
		// blcFinal.cameras = [camOther];
		add(blcFinal);
		blcFinal.scrollFactor.set();

		blcFinal.screenCenter();
		blcFinal.alpha = 0;

		sprFrameGroup = new FlxSpriteGroup();
		sprFrameGroup.scrollFactor.set();
		// sprFrameGroup.cameras = [camOther];
		add(sprFrameGroup);

		// cameraLogo.bgColor.alpha = 0;
		// FlxG.cameras.add(cameraLogo, false);
		// CustomFadeTransition.nextCamera = cameraLogo;
		creditText = new FlxText(0, 0, FlxG.width, '', 30);
		creditText.setFormat(Paths.font("DroidSerif-Regular.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		creditText.cameras = [camOther];
		creditText.screenCenter();
		creditText.scrollFactor.set();
		add(creditText);
		creditText.alpha = 0;
	}

	override function update(elapsed:Float)
	{
		// Code here
	}

	
	override function countdownTick(count:Countdown, num:Int)
	{
		switch(count)
		{
			case THREE: //num 0
			case TWO: //num 1
			case ONE: //num 2
			case GO: //num 3
			case START: //num 4
		}
	}

	override function startSong()
	{
		// PlayState.instance.cameraSpeed = cameraSD;
		FlxTween.tween(blackScreen, {alpha: 0}, 1);
	}

	// Steps, Beats and Sections:
	//    curStep, curDecStep
	//    curBeat, curDecBeat
	//    curSection
	override function stepHit()
	{
		// Code here
	}
	override function beatHit()
	{
		// Code here
	}
	override function sectionHit()
	{
		// Code here
	}

	var startDuet:Bool = false;
	override function onMoveCamera(focus:String)
	{
		if (!startDuet){
			switch(focus){
				case 'boyfriend':
					defaultCamZoom = startCamZoom;
				case 'dad':
					defaultCamZoom = startCamZoom;
			}
		}
	}

	// Substates for pausing/resuming tweens and timers
	override function closeSubState()
	{
		if(paused)
		{
			//timer.active = true;
			//tween.active = true;
		}
	}

	override function openSubState(SubState:flixel.FlxSubState)
	{
		if(paused)
		{
			//timer.active = false;
			//tween.active = false;
		}
	}

	// For events
	var curFrameSpr:Int = -1;
	var blcTheme:FlxSprite = null;
	var curCredit:Int = 0;
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case 'Duet Moment':
				startDuet = !startDuet;
				if (startDuet){
					PlayState.instance.triggerEvent("Camera Follow Pos", "1000","800", Conductor.songPosition);
					defaultCamZoom = 0.65;
				}
				else{
					PlayState.instance.triggerEvent("Camera Follow Pos", "","", Conductor.songPosition);
					// PlayState.SONG.notes[PlayState.instance.sec]
					// onMoveCamera()
				}

			case "History Frames":
				var boolValue:Bool = false;
				if (flValue1 != null){
					curFrameSpr = Std.int(flValue1);
					boolValue = true;
				}
				else if (value1.trim() == '' || value1.trim() == null) {
					curFrameSpr++;
					boolValue = true;
				}

				trace("curFrameSpr: " + curFrameSpr);
		
				if (!boolValue){
					switch(value1){
						case 'start':
							var timerValue:Float = 1;
							if (flValue2 != null) timerValue = flValue2;
							// FlxG.camera.fade()
							blcTheme = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
							blcTheme.cameras = [camOther];
							add(blcTheme);
							blcTheme.alpha = 0;

							FlxTween.tween(blcTheme, {alpha: 1}, timerValue);
						case 'endend':
							var timerValue:Float = 0.5;
							if (flValue2 != null) timerValue = flValue2;

							// FlxTween.tween(blcFinal, {alpha: 1}, timerValue);
							FlxTween.tween(sprFrameGroup.members[curFrameSpr], {alpha: 0}, timerValue);
							blcFinal.alpha = 1;
							// sprFrameGroup
						case 'end':
							// camOther.fade(FlxColor.BLACK, 0.01, false);
							var timerValue:Float = 0.8;
							if (flValue2 != null) timerValue = flValue2;
							// camOther.setFilters([]);

							// camHUD.alpha = 0;

							FlxTween.tween(sprFrameGroup.members[curFrameSpr], {alpha: 0}, timerValue);
							FlxTween.tween(camHUD, {alpha: 1}, timerValue);

						case 'ketto':
							var timerValue:Float = 1.5;
							if (flValue2 != null) timerValue = flValue2;

							var blurPower:BlurFilter = new BlurFilter(0,0,0);
							// blurPower.quality
							camGame.setFilters([blurPower]);
							FlxTween.tween(blurPower, {blurX: 6, blurY: 6, quality: 1}, timerValue);

							// var kotto = new BGSprite('kettoBg');
							var kotto:FlxText = new FlxText(0, 0, FlxG.width, "Kettō", 30);
							kotto.setFormat(Paths.font("DroidSerif-Regular.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
							kotto.cameras = [camOther];
							kotto.screenCenter();
							add(kotto);
							kotto.alpha = 0;

							FlxTween.tween(kotto, {alpha: 1}, timerValue);
					
						case 'credit':
							var creditsSong:Array<String> = [
								'Mod Direction:\nAllyTS',
								'Concept Art and Design:\nCelly',
								'Sprites and Animation:\nAllyTS and Celly',
								'Background:\nAllyTS and Low Tus',
								'Cutscene and Menu Art:\nLow Tus',
								'Music:\nShifty, Low Tus and AllyTS',
								'Chart:\nAizakku and PheSpriter',
								'Coding:\nNati',
								''
							];

							// FlxTween.tween(kotto, {alpha: 1}, timerValue/2);
							// if (creditText.text.trim() != '' || creditText.text.trim() != null){

							// }
							var timerValue:Float = 1.5;
							if (flValue2 != null) timerValue = flValue2;

							FlxTween.tween(creditText, {alpha: 0}, (creditText.alpha <= 0) ? 0.01 : timerValue/2, {onComplete: function(t:FlxTween){
								creditText.text = creditsSong[curCredit];
								creditText.screenCenter();
								// creditText.y += 300;
								FlxTween.tween(creditText, {alpha: 1}, timerValue/2);
								curCredit++;
							}});

					}
				} else {
					if (blcTheme != null) 
						remove(blcTheme);
					
					// camOther.setFilters([new ShaderFilter(shader.shader)]);
					if (curFrameSpr >= 5)
						camGame.setFilters([]);

					camHUD.alpha = 0;
					sprFrameGroup.forEach(function(spr:FlxSprite){
						spr.alpha = 0;
						if (spr.ID == curFrameSpr) spr.alpha = 1;
					});
				}
		}
	}
	override function eventPushed(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events that doesn't need different assets based on its values
		switch(event.event)
		{
			case "History Frames":
				var eventFlxSprite:Array<String> = [
					'stage2_frame1',
					'stage2_frame2',
					'stage2_frame3',
					'stage2_frame4',
					'stage2_frame5',
					'stage2_frame6',
					'stage2_frame7',
					'stage2_frame8',
					'bgTheme',
					'stage2_frame9',
					// 'logo'
				];

				// 0xFF404040

				for (i in 0...eventFlxSprite.length){
					var curSprite:String = eventFlxSprite[i];
					var sprFrame:FlxSprite;
					if (curSprite != 'bgTheme'){
						sprFrame = new BGSprite('kitchen/history/$curSprite');
						sprFrame.setGraphicSize(FlxG.width,FlxG.height);
					} else {
						sprFrame = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,0xFF404040);
					}

					sprFrame.scale.x /= defaultCamZoom/1.5;
					sprFrame.scale.y /= defaultCamZoom/1.5;

					sprFrame.scale.x += 0.05;
					sprFrame.scale.y += 0.05;

					sprFrameGroup.add(sprFrame);			
					sprFrame.screenCenter();
					sprFrame.ID = i;
					sprFrame.alpha = 0;	
				}
		}
	}
	override function eventPushedUnique(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events where its values affect what assets should be preloaded
		switch(event.event)
		{
			case "My Event":
				switch(event.value1)
				{
					// If value 1 is "blah blah", it will preload these assets:
					case 'blah blah':
						//precacheImage('myImageOne') //preloads images/myImageOne.png
						//precacheSound('mySoundOne') //preloads sounds/mySoundOne.ogg
						//precacheMusic('myMusicOne') //preloads music/myMusicOne.ogg

					// If value 1 is "coolswag", it will preload these assets:
					case 'coolswag':
						//precacheImage('myImageTwo') //preloads images/myImageTwo.png
						//precacheSound('mySoundTwo') //preloads sounds/mySoundTwo.ogg
						//precacheMusic('myMusicTwo') //preloads music/myMusicTwo.ogg
					
					// If value 1 is not "blah blah" or "coolswag", it will preload these assets:
					default:
						//precacheImage('myImageThree') //preloads images/myImageThree.png
						//precacheSound('mySoundThree') //preloads sounds/mySoundThree.ogg
						//precacheMusic('myMusicThree') //preloads music/myMusicThree.ogg
				}
		}
	}
}