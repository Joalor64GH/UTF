package utf.states.config;

import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxTimer;
import utf.states.config.Option;
import utf.states.Intro;
import utf.util.FilterUtil;

/**
 * Manages the settings menu, allowing users to configure various options.
 */
class Settings extends FlxState
{
	var selected:Int = 0;
	final options:Array<Option> = [];
	var items:FlxTypedGroup<FlxText>;

	var holdTimer:FlxTimer;
	var holdDirection:Int = 0;

	public function new():Void
	{
		super();

		options.push(new Option('Exit', OptionType.Function, function():Void
		{
			FlxG.switchState(() -> new Intro());
		}));

		final option:Option = new Option('Master Volume', OptionType.Integer(0, 100, 1), FlxG.sound.volume * 100);
		option.showPercentage = true;
		option.onChange = (value:Dynamic) -> FlxG.sound.volume = value / 100;
		options.push(option);

		final option:Option = new Option('Filter', OptionType.Choice(FilterUtil.getFiltersKeys().concat(['none'])), Data.settings.get('filter'));
		option.onChange = (value:Dynamic) -> FilterUtil.reloadGameFilter(value);
		options.push(option);

		final option:Option = new Option('Low Quality', OptionType.Toggle, Data.settings.get('low-quality'));
		option.onChange = (value:Dynamic) -> Data.updateSetting('low-quality', value);
		options.push(option);

		holdTimer = new FlxTimer();
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

		changeOption();

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (Controls.justPressed('up'))
			changeOption(-1);
		else if (Controls.justPressed('down'))
			changeOption(1);

		if (Controls.justPressed('left'))
			startHold(-1);
		else if (Controls.justPressed('right'))
			startHold(1);

		if (Controls.justReleased('left') || Controls.justReleased('right'))
		{
			if (holdTimer.active)
				holdTimer.cancel();
		}

		if (Controls.justPressed('confirm'))
		{
			final option:Option = options[selected];

			if (option != null)
				option.execute();
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
	private function changeValue(direction:Int = 0):Void
	{
		final option:Option = options[selected];

		if (option != null)
		{
			option.changeValue(direction);

			items.forEach(function(spr:FlxText):Void
			{
				if (spr.ID == selected)
					spr.text = option.toString();
			});
		}
	}

	@:noCompletion
	private function startHold(direction:Int = 0):Void
	{
		holdDirection = direction;

		final option:Option = options[selected];

		if (option != null)
		{
			if (option.type != OptionType.Function)
				changeValue(holdDirection);

			switch (option.type)
			{
				case OptionType.Integer(_, _, _) | OptionType.Decimal(_, _, _):
					if (!holdTimer.active)
					{
						holdTimer.start(0.5, function(timer:FlxTimer):Void
						{
							timer.start(0.05, function(timer:FlxTimer):Void
							{
								changeValue(holdDirection);
							}, 0);
						});
					}
				default:
			}
		}
	}
}
