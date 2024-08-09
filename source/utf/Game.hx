package utf;

import flixel.FlxG;
import flixel.FlxGame;

@:access(openfl.display.Stage)
@:access(openfl.events.UncaughtErrorEvents)
class Game extends FlxGame
{
	override function create(_):Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
				super.create(_);
			}
			catch (e:Dynamic)
			{
				#if !display
				stage.__handleError(e);
				#end
			}
		}
		else
			super.create(_);
	}

	override function onFocus(_):Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
			super.onFocus(_);
			}
			catch (e:Dynamic)
			{
				#if !display
				stage.__handleError(e);
				#end
			}
		}
		else
			super.onFocus(_);
	}

	override function onFocusLost(_):Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
			super.onFocusLost(_);
			}
			catch (e:Dynamic)
			{
				#if !display
				stage.__handleError(e);
				#end
			}
		}
		else
			super.onFocusLost(_);
	}

	override function onEnterFrame(_):Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
			super.onEnterFrame(_);
			}
			catch (e:Dynamic)
			{
				#if !display
				stage.__handleError(e);
				#end
			}
		}
		else
			super.onEnterFrame(_);
	}

	override function update():Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
			super.update();
			}
			catch (e:Dynamic)
			{
				#if !display
				stage.__handleError(e);
				#end
			}
		}
		else
			super.update();
	}

	override function draw():Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
			super.draw();
			}
			catch (e:Dynamic)
			{
				#if !display
				stage.__handleError(e);
				#end
			}
		}
		else
			super.draw();
	}

	@:allow(flixel.FlxG)
	override function onResize(_):Void
	{
		if (stage.__uncaughtErrorEvents.__enabled)
		{
			try
			{
				super.onResize(_);
			}
			catch (e:Dynamic)
			{
				#if !display
				stage.__handleError(e);
				#end
			}
		}
		else
			super.onResize(_);
	}
}
