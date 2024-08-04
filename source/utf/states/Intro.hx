package utf.states;

import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.Lib;
import utf.backend.AssetPaths;
import utf.backend.Data;
import utf.backend.Global;
import utf.input.Controls;
import utf.registries.RoomRegistry;
import utf.states.config.Settings;
import utf.states.room.Room;
#if debug
import utf.substates.battle.EnemyEncounter;
#end
import utf.substates.Naming;
#if debug
import utf.util.macro.git.GitUtil;
#end

enum Scroll
{
	WRAP;
	BOUND;
}

class Intro extends FlxState
{
	var selected:Int = 0;
	var choices:Array<String> = [];
	var items:FlxTypedGroup<FlxText>;

	override function create():Void
	{
		// FlxG.log.notice([for (contributor in GitHub.getContributors()) {name: contributor.login, commits: contributor.contributions}]);

		if (Global.flags[0] == 1)
		{
			if (!(FlxG.sound.music?.playing ?? false))
				FlxG.sound.playMusic(AssetPaths.music('menu1'));

			final bg:FlxSprite = new FlxSprite(0, -240, AssetPaths.background('floweyglow'));
			bg.scale.set(2, 2);
			bg.updateHitbox();
			bg.scrollFactor.set();
			bg.active = false;
			add(bg);

			final flowey:FlxSprite = new FlxSprite(0, 348);
			flowey.frames = AssetPaths.spritesheet('flowey');
			flowey.animation.frameIndex = 1;
			flowey.scale.set(2, 2);
			flowey.updateHitbox();
			flowey.screenCenter(X);
			flowey.scrollFactor.set();
			add(flowey);

			final name:FlxText = new FlxText(145, 120, 0, Global.name, 32);
			name.font = AssetPaths.font('DTM-Sans');
			name.scrollFactor.set();
			name.active = false;
			add(name);

			final love:FlxText = new FlxText(285, 120, 0, 'LV ${Global.lv}', 32);
			love.font = AssetPaths.font('DTM-Sans');
			love.scrollFactor.set();
			love.active = false;
			add(love);

			// TODO
			final time:FlxText = new FlxText(425, 120, 0, '0:0', 32);
			time.font = AssetPaths.font('DTM-Sans');
			time.scrollFactor.set();
			time.active = false;
			add(time);

			// TODO
			final room:FlxText = new FlxText(145, 160, 0, '---', 32);
			room.font = AssetPaths.font('DTM-Sans');
			room.scrollFactor.set();
			room.active = false;
			add(room);

			choices = ['Continue', 'Reset', 'Settings'];
		}
		else
		{
			if (!(FlxG.sound.music?.playing ?? false))
				FlxG.sound.playMusic(AssetPaths.music('menu0'));

			final instructions:FlxText = new FlxText(170, 40, 0, ' --- Instruction --- ', 32);
			instructions.font = AssetPaths.font('DTM-Sans');
			instructions.color = 0xFFC0C0C0;
			instructions.scrollFactor.set();
			instructions.active = false;
			add(instructions);

			final list:Array<String> = [
				'[${Controls.binds.get('confirm').key}] - Confirm',
				'[${Controls.binds.get('cancel').key}] - Cancel',
				'[${Controls.binds.get('menu').key}] - Menu (In-game)',
				'[F4] - Fullscreen',
				'[Hold ESC] - Quit',
				'When HP is 0, you lose.'
			];

			final instructionsList:FlxText = new FlxText(170, 100, 0, list.join('\n'), 32);
			instructionsList.font = AssetPaths.font('DTM-Sans');
			instructionsList.color = 0xFFC0C0C0;
			instructionsList.scrollFactor.set();
			instructionsList.active = false;
			add(instructionsList);

			choices = ['Begin Game', 'Settings'];
		}

		items = new FlxTypedGroup<FlxText>();

		for (i in 0...choices.length)
		{
			final bt:FlxText = new FlxText(0, 0, 0, choices[i], 32);

			if (!choices.contains('Begin Game'))
			{
				switch (choices[i])
				{
					case 'Continue':
						bt.setPosition(170, 210);
					case 'Reset':
						bt.setPosition(385, 210);
					case 'Settings':
						bt.setPosition(260, 250);
				}
			}
			else
			{
				switch (choices[i])
				{
					case 'Begin Game':
						bt.setPosition(170, 320);
					case 'Settings':
						bt.setPosition(170, 360);
				}
			}

			bt.font = AssetPaths.font('DTM-Sans');
			bt.ID = i;
			bt.scrollFactor.set();
			bt.active = false;
			items.add(bt);
		}

		add(items);

		#if debug
		var info:FlxText = new FlxText(0, FlxG.height - 40, 0,
			'UTF v${Lib.application.meta['version']} (c) MAJigsaw77 2023\nCommit (${GitUtil.getCommitHash()})', 16);
		#else
		var info:FlxText = new FlxText(0, FlxG.height - 20, 0, 'UTF v${Lib.application.meta['version']} (c) MAJigsaw77 2023', 16);
		#end
		info.alignment = CENTER;
		info.font = AssetPaths.font('Small');
		info.color = FlxColor.GRAY;
		info.screenCenter(X);
		info.scrollFactor.set();
		info.active = false;
		add(info);

		changeOption();

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (Global.flags[0] == 1)
		{
			if (Controls.justPressed('right'))
				changeOption(1, WRAP);
			else if (Controls.justPressed('left'))
				changeOption(-1, WRAP);
		}
		else
		{
			if (Controls.justPressed('down'))
				changeOption(1, BOUND);
			else if (Controls.justPressed('up'))
				changeOption(-1, BOUND);
		}

		if (Controls.justPressed('confirm'))
		{
			if (FlxG.sound.music != null
				&& FlxG.sound.music.playing
				&& (choices[selected] != 'Reset' && choices[selected] != 'Begin Game'))
				FlxG.sound.music.stop();

			switch (choices[selected])
			{
				case 'Continue':
					FlxG.switchState(() -> RoomRegistry.fetchRoom(272));
				case 'Begin Game':
					openSubState(new Naming());
				case 'Settings':
					FlxG.switchState(() -> new Settings());
			}
		}

		#if debug
		if (FlxG.keys.justPressed.B)
		{
			if (FlxG.sound.music != null && FlxG.sound.music.playing)
				FlxG.sound.music.stop();

			openSubState(new EnemyEncounter());
		}
		#end

		super.update(elapsed);
	}

	@:noCompletion
	private function changeOption(num:Int = 0, scrollType:Scroll = BOUND):Void
	{
		switch (scrollType)
		{
			case WRAP:
				selected = FlxMath.wrap(selected + num, 0, choices.length - 1);
			case BOUND:
				selected = Math.floor(FlxMath.bound(selected + num, 0, choices.length - 1));
		}

		items.forEach(function(spr:FlxText):Void
		{
			spr.color = spr.ID == selected ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}
}
