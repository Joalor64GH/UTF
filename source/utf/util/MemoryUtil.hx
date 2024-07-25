package utf.util;

import openfl.system.System;

/**
 * Utility class for working with the garbage collector.
 */
class MemoryUtil
{
	/**
	 * Returns the total memory used by the program, in bytes.
	 * @return The memory used by the program.
	 */
	public static function getMemoryUsed():Int
	{
		return System.totalMemory;
	}

	/**
	 * Enables garbage collection.
	 */
	public static function enable():Void
	{
		#if cpp
		cpp.vm.Gc.enable(true);
		#end
	}

	/**
	 * Disables garbage collection.
	 */
	public static function disable():Void
	{
		#if cpp
		cpp.vm.Gc.enable(false);
		#end
	}

	/**
	 * Runs garbage collection. Should be called from the main thread.
	 * @param major  Set to true to perform a major collection.
	 */
	public static function collect(?major:Bool = false):Void
	{
		#if cpp
		cpp.vm.Gc.run(major);
		#end
	}

	/**
	 * Performs repeated major garbage collection until less than 16KB is freed in one operation.
	 * Should be called from the main thread.
	 */
	public static function compact():Void
	{
		#if cpp
		cpp.vm.Gc.compact();
		#end
	}
}
