package utf.states;

import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import utf.input.Controls;
import utf.backend.AssetPaths;
import utf.backend.Data;
import utf.backend.Global;
import utf.states.Intro;

typedef Option =
{
	var name:String;
	var type:OptionType;
	var value:Dynamic;
}

enum OptionType
{
	Toggle;
	Integer(min:Int, max:Int, step:Int);
	Decimal(min:Float, max:Float, step:Float);
	Function;
}

class Settings extends FlxState
{
	var selected:Int = 0;

	final options:Array<Option> = [
		{
			name: 'Exit',
			type: Function,
			value: () -> FlxG.switchState(() -> new Intro())
		},
		{
			name: 'Master Volume',
			type: Decimal(0.0, 100.0, 1.0),
			value: 50.0
		}
	];

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
			final opt:FlxText = new FlxText(40, 80 + i * 32, 0, optionToString(options[i]), 32);
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

		if (Controls.justPressed('left'))
			changeValue(-1);
		else if (Controls.justPressed('right'))
			changeValue(1);

		if (Controls.justPressed('confirm'))
		{
			final option:Option = options[selected];

			switch (option.type)
			{
				case Function:
					option.value();
			}
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

	private function changeValue(direction:Int):Void
	{
		final option:Option = options[selected];

		switch (option.type)
		{
			case Toggle:
				option.value = !option.value;
			case Integer(min, max, step):
				option.value = FlxMath.bound(option.value + direction * step, min, max);
			case Decimal(min, max, step):
				option.value = FlxMath.bound(option.value + direction * step, min, max);
		}

		items.members[selected].text = optionToString(option);

		if (option.name == 'Master Volume')
			FlxG.sound.volume = option.value / 100;
	}

	private function optionToString(option:Option):String
	{
		switch (option.type)
		{
			case Toggle:
				return '${option.name}: ${option.value ? 'On' : 'Off'}';
			case Integer(_, _, _) | Decimal(_, _, _):
				return '${option.name}: ${option.value}';
			case Function:
				return option.name;
		}

		return '';
	}
}
