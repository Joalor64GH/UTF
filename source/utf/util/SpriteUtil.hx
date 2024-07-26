package utf.util;

import flixel.FlxObject;
import flixel.util.FlxAxes;

/**
 * Utility class for performing operations on FlxObject instances.
 */
class ObjectUtil
{
	/**
	 * Calculates the bottom position of the given FlxObject.
	 * @param obj The FlxObject instance.
	 * @return The bottom position (y + height) or 0 if the object is null.
	 */
	public static function getBottom(obj:FlxObject):Float
	{
		return obj == null ? 0 : (obj.y + obj.height);
	}

	/**
	 * Calculates the right position of the given FlxObject.
	 * @param obj The FlxObject instance.
	 * @return The right position (x + width) or 0 if the object is null.
	 */
	public static function getRight(obj:FlxObject):Float
	{
		return obj == null ? 0 : (obj.x + obj.width);
	}

	/**
	 * Centers one FlxObject within another along specified axes.
	 * @param obj The FlxObject to center.
	 * @param base The base FlxObject to center within.
	 * @param axes The axes along which to center (default is both X and Y).
	 * @return The centered FlxObject.
	 */
	public static function centerObject(obj:FlxObject, base:FlxObject, ?axes:FlxAxes = FlxAxes.XY):Void
	{
		if (obj == null || base == null)
			return;

		if (axes.x)
			obj.x = base.x + (base.width - obj.width) / 2;

		if (axes.y)
			obj.y = base.y + (base.height - obj.height) / 2;
	}
}
