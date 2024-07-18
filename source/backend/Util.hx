package backend;

#if android
import android.Tools;
#end
import openfl.Lib;
import flixel.FlxG;

/**
 * Utility class for common backend functions.
 */
class Util
{
	/**
	 * Show a popup with the given text.
	 * 
	 * @param name The title of the popup.
	 * @param desc The content of the popup.
	 */
	public static function showAlert(name:String, desc:String):Void
	{
		#if !android
		Lib.application.window.alert(desc, name);
		#else
		Tools.showAlertDialog(name, desc, {name: 'Ok', func: null});
		#end
	}

	/**
	 * Get a random number between a and b.
	 *
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
	 *
	 * @param n The dividend.
	 * @param m The divisor.
	 * @return The positive modulo result.
	 */
	public static inline function mod(n:Int, m:Int):Int
	{
		return ((n % m) + m) % m;
	}

	/**
	 * Get the current season as a number.
	 *
	 * @return 1 for Winter, 2 for Spring, 3 for Summer, 4 for Autumn.
	 */
	public static function getWeather():Int
	{
		final curDate:Date = Date.now();

		switch (curDate.getMonth() + 1)
		{
			case 12 | 1 | 2:
				return 1;
			case 3 | 4 | 5:
				return 2;
			case 6 | 7 | 8:
				return 3;
			case 9 | 10 | 11:
				return 4;
		}

		return 0;
	}
}
