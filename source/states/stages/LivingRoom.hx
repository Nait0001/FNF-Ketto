package states.stages;

import openfl.display.BlendMode;
import openfl.filters.ShaderFilter;
import states.stages.objects.*;

class LivingRoom extends BaseStage
{
	// If you're moving your stage from PlayState to a stage file,
	// you might have to rename some variables if they're missing, for example: camZooming -> game.camZooming

	var blackScreen:FlxSprite;
	var blackScreenHUD:FlxSprite;
	var cameraSD:Float;
	var vhs:BGSprite;
	override function create()
	{
		var livingroom:BGSprite = new BGSprite('livingroom/livingroom');
		add(livingroom);

		var tvlight:BGSprite = new BGSprite('livingroom/tvlight');
		add(tvlight);
		tvlight.blend = BlendMode.ADD;

		PlayState.instance.addCinematicBar();

		var scaleVHS:Float = 1.7;
		vhs = new BGSprite('vhs', 0, 0, 1, 1, ["giphy_gif00"], true);
		vhs.setGraphicSize(Std.int(FlxG.width * scaleVHS),FlxG.height);
		vhs.screenCenter();
		vhs.x -= 250;
		vhs.cameras = [camHUD];
		vhs.alpha = 0.5;
		add(vhs);
		vhs.dance(true);
		// vhs.dance(true);

		// FlxG.log.add("blend: " + tvlight.blend);

		blackScreen = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		blackScreen.cameras = [camOther];
		add(blackScreen);

		
		blackScreenHUD = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		blackScreenHUD.cameras = [camHUD];
		add(blackScreenHUD);
		PlayState.instance.visibleDad = false;
		// Spawn your stage sprites here.
		// Characters are not ready yet on this function, so you can't add things above them yet.
		// Use createPost() if that's what you want to do.
	}
	
	var startCamZoom:Float;
	var sprFrameGroup:FlxSpriteGroup = null;
	var shader:shaders.VCRDistortionEffect;
	override function createPost()
	{
		shader = new shaders.VCRDistortionEffect();
		shader.setCurvate(false);
		// shader.setGlitchModifier(-0.);
		camGame.setFilters([new ShaderFilter(shader.shader)]);
		// Use this function to layer things above characters!
		
		dad.visible = false;
		// PlayState.instance.iconP1.visible = false;
		// PlayState.instance.healthBar.rightBar.color = PlayState.instance.healthBar.leftBar.color;
		cameraSD = PlayState.instance.cameraSpeed;
		PlayState.instance.cameraSpeed = 99999999;
		startCamZoom = defaultCamZoom;
		PlayState.instance.skipCountdown = true;
		// PlayState.instance.iconP1.visible = false;

		
		sprFrameGroup = new FlxSpriteGroup();
		sprFrameGroup.scrollFactor.set();
		// sprFrameGroup.cameras = [camHUD];
		add(sprFrameGroup);
	}

	override function update(elapsed:Float)
	{
		// Code here
	}

	// onMoveCamera;

	override function onMoveCamera(focus:String)
	{
		if (zoomMoveCamera){
			switch(focus){
				case 'boyfriend':
					defaultCamZoom = startCamZoom;
				case 'dad':
					defaultCamZoom = 1.5;
			}
		}
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
		PlayState.instance.cameraSpeed = cameraSD;
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
	var zoomMoveCamera:Bool = true;
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
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

				// if (boolValue) 
				// if (blcTheme != null) remove(blcTheme);

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
						case 'start fone':
							FlxTween.tween(blackScreenHUD, {alpha: 0}, 3);
						case 'end':
							// camOther.fade(FlxColor.BLACK, 0.01, false);
							var timerValue:Float = 0.8;
							if (flValue2 != null) timerValue = flValue2;

							FlxTween.tween(sprFrameGroup.members[curFrameSpr], {alpha: 0}, timerValue);
					}
				} else {
					if (blcTheme != null) {
						remove(blcTheme);
					}
					camHUD.visible = zoomMoveCamera = false;
					defaultCamZoom = 0.9;
					PlayState.instance.camZooming = false;
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
					'stage1_frame1',
					'stage1_frame2',
					'blackTheme',
					'stage1_frame3',
					'stage1_frame4',
					'stage1_frame5',
					'stage1_frame6',
					'stage1_frame7',
				];

				for (i in 0...eventFlxSprite.length){
					var curSprite:String = eventFlxSprite[i];
					var sprFrame:FlxSprite;
					if (curSprite != 'blackTheme'){
						sprFrame = new BGSprite('livingroom/history/$curSprite');
						sprFrame.setGraphicSize(FlxG.width,FlxG.height);
					}
					else 
						sprFrame = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);

					sprFrame.screenCenter();
					sprFrame.ID = i;
					sprFrame.scrollFactor.set();
					sprFrameGroup.add(sprFrame);			
					sprFrame.alpha = 0;	
				}


				//precacheImage('myImage') //preloads images/myImage.png
				//precacheSound('mySound') //preloads sounds/mySound.ogg
				//precacheMusic('myMusic') //preloads music/myMusic.ogg
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