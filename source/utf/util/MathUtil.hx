package utf.util;

import flixel.FlxG;

/**
 * Utility class for mathematical calculations and random number generation.
 */
class MathUtil
{
	/**
	 * Get a random number between a and b.
	 * @param a The lower limit.
	 * @param b The upper limit.
	 * @return A random number between a and b.
	 */
	public static inline function randomRange(a:Float, b:Float):Float
	{
		return FlxG.random.float(0, Math.abs(a - b)) + Math.min(a, b);
	}

	/**
	 * Calculate the positive modulo of n by m.
	 * @param n The dividend.
	 * @param m The divisor.
	 * @return The positive modulo result.
	 */
	public static inline function mod(n:Int, m:Int):Int
	{
		return ((n % m) + m) % m;
	}

	/**
	 * Restricts a value to be within a specified range.
	 * @param value The value to clamp.
	 * @param min The minimum value allowed.
	 * @param max The maximum value allowed.
	 * @return The clamped value.
	 */
	public static function clamp(value:Float, min:Float, max:Float):Float
	{
		return Math.max(min, Math.min(max, value));
	}
}
