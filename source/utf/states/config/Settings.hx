package utf.states.config;

import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxTimer;
import utf.states.config.Option;
import utf.states.Intro;
import utf.util.DateUtil;
import utf.util.FilterUtil;

/**
 * Manages the settings menu, allowing users to configure various options.
 */
class Settings extends FlxState
{
	@:noCompletion
	private var selected:Int = 0;

	@:noCompletion
	private final options:Array<Option> = [];

	@:noCompletion
	private var items:FlxTypedGroup<FlxText>;

	@:noCompletion
	private var holdTimer:FlxTimer;

	@:noCompletion
	private var holdDirection:Int = 0;

	@:noCompletion
	private var tobdogLine:FlxText;

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

	public override function create():Void
	{
		persistentUpdate = false;

		switch (DateUtil.getWeather())
		{
			case 1:
				AssetPaths.music('options_winter');
			case 3:
				AssetPaths.music('options_summer');
			default:
				AssetPaths.music('options_fall');
		}

		if (DateUtil.getWeather() != 3)
		{
			final particles:FlxEmitter = new FlxEmitter(0, 0);
			particles.loadParticles(AssetPaths.sprite(DateUtil.getWeather() == 1 ? 'christmasflake' : 'fallleaf'), 120);
			particles.alpha.set(0.5, 0.5);
			particles.scale.set(2, 2);

			switch (DateUtil.getWeather())
			{
				case 2:
					particles.color.set(FlxColor.interpolate(FlxColor.RED, FlxColor.WHITE, 0.5));
				case 4:
					particles.color.set(FlxColor.YELLOW, FlxColor.fromRGB(255, 159, 64), FlxColor.RED);
			}

			particles.width = FlxG.width;
			particles.launchMode = SQUARE;
			particles.acceleration.set(120, 120, 120, 120);
			particles.velocity.set(-10, 80, 0, FlxG.height);
			particles.start(false, 0.01);
			add(particles);
		}

		final settings:FlxText = new FlxText(0, 20, 0, 'SETTINGS', 64);
		settings.font = AssetPaths.font('DTM-Sans');
		settings.screenCenter(X);
		settings.scrollFactor.set();
		settings.active = false;
		add(settings);

		items = new FlxTypedGroup<FlxText>();

		for (i in 0...options.length)
		{
			final opt:FlxText = new FlxText(40, i == 0 ? 80 : (120 + i * 32), 0, options[i].toString(), 32);
			opt.font = AssetPaths.font('DTM-Sans');
			opt.scrollFactor.set();
			opt.active = false;
			opt.ID = i;
			items.add(opt);
		}

		add(items);

		final tobdogWeather:FlxSprite = new FlxSprite(500, 436);

		switch (DateUtil.getWeather())
		{
			case 1:
				tobdogWeather.loadGraphic(AssetPaths.sprite('tobdog_winter'));
			case 2:
				tobdogWeather.frames = AssetPaths.spritesheet('tobdog_spring');
				tobdogWeather.animation.addByPrefix('spring', 'tobdog_spring', 2, true);
				tobdogWeather.animation.play('spring');
			case 3:
				tobdogWeather.frames = AssetPaths.spritesheet('tobdog_summer');
				tobdogWeather.animation.addByPrefix('summer', 'tobdog_summer', 2, true);
				tobdogWeather.animation.play('summer');
			case 4:
				tobdogWeather.loadGraphic(AssetPaths.sprite('tobdog_autumn'));
		}

		tobdogWeather.scale.set(2, 2);
		tobdogWeather.updateHitbox();
		tobdogWeather.scrollFactor.set();

		if (DateUtil.getWeather() != 2 && DateUtil.getWeather() != 3)
			tobdogWeather.active = false;

		add(tobdogWeather);

		tobdogLine = new FlxText(420, 260, 0, '', 32);

		switch (DateUtil.getWeather())
		{
			case 1:
				tobdogLine.text = 'cold outside\nbut stay warm\ninside of you';
			case 2:
				tobdogLine.text = 'spring time\nback to school';
			case 3:
				tobdogLine.text = 'try to withstand\nthe sun\'s life-\ngiving rays';
			case 4:
				tobdogLine.text = 'sweep a leaf\nsweep away a\ntroubles';
		}

		tobdogLine.font = AssetPaths.font('DTM-Sans');
		tobdogLine.color = FlxColor.GRAY;
		tobdogLine.angle = 20;
		tobdogLine.scrollFactor.set();
		tobdogLine.active = false;
		add(tobdogLine);

		changeOption();

		FlxG.sound.play(AssetPaths.music('harpnoise'));

		super.create();

		FlxTimer.wait(1.5, function():Void
		{
			switch (DateUtil.getWeather())
			{
				case 1:
					FlxG.sound.playMusic(AssetPaths.music('options_winter'), 0.8);
				case 3:
					FlxG.sound.playMusic(AssetPaths.music('options_summer'), 0.8);
				default:
					FlxG.sound.playMusic(AssetPaths.music('options_fall'), 0.8);
			}
		});
	}

	public override function update(elapsed:Float):Void
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

		tobdogLine.centerOffsets();

		tobdogLine.offset.add(Math.sin(FlxG.game.ticks / 12), Math.cos(FlxG.game.ticks / 12));
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
