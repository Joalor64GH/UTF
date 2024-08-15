package utf;

import flixel.FlxG;
import flixel.FlxGame;

/**
 * Custom game class that extends FlxGame, incorporating error handling for various lifecycle events.
 * This class ensures that uncaught errors during the game's execution are handled appropriately
 * by leveraging the stage's error handling mechanisms when enabled.
 */
@:access(openfl.display.Stage)
@:access(openfl.events.UncaughtErrorEvents)
class Game extends FlxGame
{
	@:noCompletion
	private override function create(_):Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
				super.create(_);
			}
			catch (e:Dynamic)
				stage.__handleError(e);
		}
		else
			super.create(_);
	}

	@:noCompletion
	private override function onFocus(_):Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
				super.onFocus(_);
			}
			catch (e:Dynamic)
				stage.__handleError(e);
		}
		else
			super.onFocus(_);
	}

	@:noCompletion
	private override function onFocusLost(_):Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
				super.onFocusLost(_);
			}
			catch (e:Dynamic)
				stage.__handleError(e);
		}
		else
			super.onFocusLost(_);
	}

	@:noCompletion
	private override function onEnterFrame(_):Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
				super.onEnterFrame(_);
			}
			catch (e:Dynamic)
				stage.__handleError(e);
		}
		else
			super.onEnterFrame(_);
	}

	@:noCompletion
	private override function update():Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
				super.update();
			}
			catch (e:Dynamic)
				stage.__handleError(e);
		}
		else
			super.update();
	}

	@:noCompletion
	private override function draw():Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
				super.draw();
			}
			catch (e:Dynamic)
				stage.__handleError(e);
		}
		else
			super.draw();
	}

	@:noCompletion
	private override function onResize(_):Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
				super.onResize(_);
			}
			catch (e:Dynamic)
				stage.__handleError(e);
		}
		else
			super.onResize(_);
	}
}
