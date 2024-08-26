package utf.states.config;

import flixel.addons.display.shapes.FlxShapeCircle;
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

using flixel.util.FlxSpriteUtil;

/**
 * Manages the settings menu, allowing users to configure various options.
 */
class Settings extends FlxState
{
	@:noCompletion
	private static final CIRCLE_RADIUS:Float = 56;

	@:noCompletion
	private var selected:Int = 0;

	@:noCompletion
	private final options:Array<Option> = [];

	@:noCompletion
	private var items:FlxTypedGroup<FlxText>;

	@:noCompletion
	private var holdTimer:FlxTimer;

	@:noCompletion
	private var weather:Int = 0;

	@:noCompletion
	private var holdDirection:Int = 0;

	@:noCompletion
	private var tobdogWeather:FlxSprite;

	@:noCompletion
	private var tobdogLine:FlxText;

	@:noCompletion
	private var siner:Float = 0;

	@:noCompletion
	private var extreme:Float = 0;

	@:noCompletion
	private var extreme2:Float = 0;

	@:noCompletion
	private var sun:FlxShapeCircle;

	public function new():Void
	{
		super();

		weather = DateUtil.getWeather();

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

		switch (weather)
		{
			case 1:
				Paths.music('options_winter');
			case 3:
				Paths.music('options_summer');
			default:
				Paths.music('options_fall');
		}

		if (weather != 3)
		{
			final particles:FlxEmitter = new FlxEmitter(0, 0);
			particles.loadParticles(Paths.sprite(weather == 1 ? 'christmasflake' : 'fallleaf'), 120);
			particles.alpha.set(0.5, 0.5);
			particles.scale.set(2, 2);

			switch (weather)
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
		settings.font = Paths.font('DTM-Sans');
		settings.screenCenter(X);
		settings.scrollFactor.set();
		settings.active = false;
		add(settings);

		items = new FlxTypedGroup<FlxText>();

		for (i in 0...options.length)
		{
			final opt:FlxText = new FlxText(40, i == 0 ? 80 : (120 + i * 32), 0, options[i].toString(), 32);
			opt.font = Paths.font('DTM-Sans');
			opt.scrollFactor.set();
			opt.active = false;
			opt.ID = i;
			items.add(opt);
		}

		add(items);

		if (weather == 3)
		{
			sun = new FlxShapeCircle(516, 80, CIRCLE_RADIUS, {thickness: 0}, FlxColor.YELLOW);
			sun.active = false;
			add(sun);
		}

		tobdogWeather = new FlxSprite(weather == 3 ? 450 : 500, weather == 3 ? 400 : 436);

		switch (weather)
		{
			case 1:
				tobdogWeather.loadGraphic(Paths.sprite('tobdog_winter'));
			case 2:
				tobdogWeather.frames = Paths.spritesheet('tobdog_spring');
				tobdogWeather.animation.addByPrefix('spring', 'tobdog_spring', 2, true);
				tobdogWeather.animation.play('spring');
			case 3:
				tobdogWeather.frames = Paths.spritesheet('tobdog_summer');
				tobdogWeather.animation.addByPrefix('summer', 'tobdog_summer', 2, true);
				tobdogWeather.animation.play('summer');
			case 4:
				tobdogWeather.loadGraphic(Paths.sprite('tobdog_autumn'));
		}

		tobdogWeather.scale.set(2, 2);
		tobdogWeather.updateHitbox();
		tobdogWeather.scrollFactor.set();

		if (weather != 2 && weather != 3)
			tobdogWeather.active = false;

		add(tobdogWeather);

		tobdogLine = new FlxText(420, 260, 0, '', 32);

		switch (weather)
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

		tobdogLine.font = Paths.font('DTM-Sans');
		tobdogLine.color = FlxColor.GRAY;
		tobdogLine.angle = 20;
		tobdogLine.scrollFactor.set();
		tobdogLine.active = false;
		add(tobdogLine);

		changeOption();

		FlxG.sound.play(Paths.music('harpnoise'));

		super.create();

		FlxTimer.wait(1.5, function():Void
		{
			switch (weather)
			{
				case 1:
					FlxG.sound.playMusic(Paths.music('options_winter'), 0.8);
				case 3:
					FlxG.sound.playMusic(Paths.music('options_summer'), 0.8);
				default:
					FlxG.sound.playMusic(Paths.music('options_fall'), 0.8);
			}
		});
	}

	public override function update(elapsed:Float):Void
	{
		if (weather == 3)
		{
		extreme2++;

		if (extreme2 >= 240)
		{
			extreme++;

			if (extreme >= 1100 && Math.abs(Math.sin(siner / 15)) > 0.1)
				extreme = extreme2 = 0;
		}
		}

		if (siner >= FlxMath.MAX_VALUE_INT)
			siner = 0;

		siner++;

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

		if (sun != null)
		{
			@:privateAccess
			sun.offset.set(sun.getStrokeOffsetX(), sun.getStrokeOffsetY());
			sun.offset.add(-Math.cos(siner / 18) * 6, -Math.sin(siner / 18) * 6);
			sun.radius = CIRCLE_RADIUS + Math.sin(siner / 6) * 4;
		}

		if (weather == 3)
			tobdogWeather.scale.set(4 + Math.sin(siner / 15) * (0.2 + extreme / 900), 4 - Math.sin(siner / 15) * (0.2 + extreme / 900));

		tobdogLine.centerOffsets();

		tobdogLine.offset.add(-Math.sin(siner / 12), -Math.cos(siner / 12));
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
