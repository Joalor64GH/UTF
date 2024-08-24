package utf.util;

import flixel.FlxG;
import openfl.Lib;

/**
 * Utility class for handling framerate-related operations.
 */
class FramerateUtil
{
	/**
	 * The timing of a single frame.
	 *
	 * @see https://github.com/LavaStudios/CreateYourDroid/blob/4a5001b16f399a070d1f8d0c1256fba9bb9764ca/Assets/Scripts/Text/TextManager.cs#L72
	 */
	public static final SINGLE_FRAME_TIMING:Float = 1.0 / 20;

	/**
	 * Adjusts the stage framerate to match the display's refresh rate.
	 * If the refresh rate is below 60 Hz, the framerate is set to 60 FPS.
	 * This adjustment does not influence Flixel's `FlxGame` framerate.
	 */
	public static function adjustStageFramerate():Void
	{
		var refreshRate:Int = Lib.application.window.displayMode.refreshRate;

		if (refreshRate < 60)
			refreshRate = 60;

		if (FlxG.stage.frameRate != refreshRate)
			FlxG.stage.frameRate = refreshRate;
	}
}
