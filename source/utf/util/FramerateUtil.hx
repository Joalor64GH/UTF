package utf.util;

import flixel.FlxG;
import openfl.Lib;

/**
 * Utility class for handling framerate-related operations.
 */
class FramerateUtil
{
	/**
	 * Adjusts the stage framerate to match the display's refresh rate.
	 * If the refresh rate is below 60 Hz, the framerate is set to 60 FPS.
	 * This adjustment does not influence Flixel's `FlxGame` framerate.
	 */
	public static function adjustStageFramerate():Void
	{
		final refreshRate:Int = Lib.application.window.displayMode.refreshRate;

		if (refreshRate < 60)
			refreshRate = 60;

		FlxG.stage.frameRate = refreshRate;
	}
}
