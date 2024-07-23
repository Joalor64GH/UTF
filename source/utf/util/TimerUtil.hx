package utf.util;

import flixel.math.FlxMath;
import haxe.Timer;

/**
 * Utility class for measuring elapsed time.
 */
class TimerUtil
{
	/**
	 * Starts the timer.
	 * @return The current time.
	 */
	public static function start():Float
	{
		return Timer.stamp();
	}

	/**
	 * Gets the elapsed time.
	 * @param start  The start time.
	 * @param end  The end time (optional).
	 * @return The elapsed time.
	 */
	static function took(start:Float, ?end:Float):Float
	{
		return (end != null ? end : Timer.stamp()) - start;
	}

	/**
	 * Gets the elapsed time in seconds as a string.
	 * @param start  The start time.
	 * @param end  The end time (optional).
	 * @param precision  The number of decimal places (optional, default is 2).
	 * @return The elapsed time in seconds.
	 */
	public static function seconds(start:Float, ?end:Float, ?precision = 2):String
	{
		return '${FlxMath.roundDecimal(took(start, end), precision)} seconds';
	}

	/**
	 * Gets the elapsed time in milliseconds as a string.
	 * @param start  The start time.
	 * @param end  The end time (optional).
	 * @return The elapsed time in milliseconds.
	 */
	public static function ms(start:Float, ?end:Float):String
	{
		return '${took(start, end) * 1000} ms';
	}
}
