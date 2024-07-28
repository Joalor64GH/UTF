package utf.util;

import flixel.FlxObject;

/**
 * Utility class for performing operations on FlxObject instances.
 */
class ObjectUtil
{
	/**
	 * Calculates the right position of the given FlxObject.
	 * @param obj The FlxObject instance.
	 * @return The right position (x + width) or 0 if the object is null.
	 */
	public static inline function getRight(obj:FlxObject):Float
	{
		return obj != null ? (obj.x + obj.width) : 0;
	}

	/**
	 * Calculates the bottom position of the given FlxObject.
	 * @param obj The FlxObject instance.
	 * @return The bottom position (y + height) or 0 if the object is null.
	 */
	public static inline function getBottom(obj:FlxObject):Float
	{
		return obj != null ? (obj.y + obj.height) : 0;
	}
}
