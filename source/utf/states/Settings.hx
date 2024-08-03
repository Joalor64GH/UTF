package utf.states.config;

import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import utf.backend.AssetPaths;
import utf.backend.Global;
import utf.input.Controls;
import utf.states.config.Option;
import utf.states.Intro;

/**
 * Manages the settings menu, allowing users to configure various options.
 */
class Settings extends FlxState
{
	var selected:Int = 0;
	final options:Array<Option> = [];
	var items:FlxTypedGroup<FlxText>;

	public function new():Void
	{
		super();

		options.push(new Option('Exit', OptionType.Function, function():Void
		{
			FlxG.switchState(() -> new Intro());
		}));

		final option:Option = new Option('Master Volume', OptionType.Integer(0, 100, 1), 100);
		option.showPercentage = true;
		option.onChange = (value:Dynamic) -> FlxG.sound.volume = value / 100;
		options.push(option);
	}

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
			final opt:FlxText = new FlxText(40, 80 + i * 32, 0, options[i].toString(), 32);
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

			if (option.type == OptionType.Function)
				option.value();
		}

		super.update(elapsed);
	}

	@:noCompletion
	private function changeOption(num:Int = 0):Void
	{
		selected = FlxMath.wrap(selected + num, 0, options.length - 1);

		items.forEach(function(spr:FlxText):Void
		{
			spr.color = spr.ID == selected ? FlxColor.YELLOW : FlxColor.WHITE;
		});
	}

	@:noCompletion
	private function changeValue(direction:Int):Void
	{
		final option:Option = options[selected];

		option.changeValue(direction);

		items.members[selected].text = option.toString();
	}
}
