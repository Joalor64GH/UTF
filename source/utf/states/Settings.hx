package utf.states;

import flixel.group.FlxGroup;
import flixel.math.FlxMath;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

import utf.input.Controls;

import utf.backend.AssetPaths;
import utf.backend.Data;
import utf.backend.Global;

import utf.states.Intro;

class Settings extends FlxState
{
	var selected:Int = 0;
	final options:Array<String> = ['Exit', 'Filter'];
	var items:FlxTypedGroup<FlxText>;

	override function create():Void
	{
		final settings:FlxText = new FlxText(0, 20, 0, 'SETTINGS', 64);
		settings.font = AssetPaths.font('DTM-Sans');
		settings.screenCenter(X);
		settings.scrollFactor.set();
		settings.active = false;
		add(settings);

		items = new FlxTypedGroup<FlxText>();

		for (i in 0...options.length)
		{
			final opt:FlxText = new FlxText(40, i == 0 ? 80 : (120 + i * 32), 0, options[i].toUpperCase(), 32);
			opt.font = AssetPaths.font('DTM-Sans');
			opt.scrollFactor.set();
			opt.active = false;
			opt.ID = i;
			items.add(opt);
		}

		add(items);

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (Controls.justPressed('up'))
			changeOption(-1);
		else if (Controls.justPressed('down'))
			changeOption(1);

		if (Controls.justPressed('confirm') && (FlxG.sound.music != null && FlxG.sound.music.playing))
		{
			if (FlxG.sound.music.playing && options[selected] == 'Exit')
				FlxG.sound.music.stop();

			switch (options[selected])
			{
				case 'Exit':
					FlxG.switchState(() -> new Intro());
			}

			Data.save();
		}

		super.update(elapsed);
	}

	@:noCompletion
	private function changeOption(num:Int = 0):Void
	{
		selected = Math.floor(FlxMath.bound(selected + num, 0, options.length - 1));

		items.forEach(function(spr:FlxText):Void
		{
			spr.color = spr.ID == selected ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}
}
