package utf.util;

#if cpp
import cpp.vm.Gc;
#elseif neko
import cpp.vm.Gc;
#elseif hl
import hl.Gc;
#end

/**
 * Utility class for working with the garbage collector.
 */
class MemoryUtil
{
	/**
	 * Enables garbage collection.
	 */
	public static function enable():Void
	{
		#if (cpp || hl)
		Gc.enable(true);
		#end
	}

	/**
	 * Disables garbage collection.
	 */
	public static function disable():Void
	{
		#if (cpp || hl)
		Gc.enable(false);
		#end
	}

	/**
	 * Runs garbage collection. Should be called from the main thread.
	 * @param major Set to true to perform a major collection.
	 */
	public static function collect(?major:Bool = false):Void
	{
		#if (cpp || neko)
		Gc.run(major);
		#end
	}

	/**
	 * Performs repeated major garbage collection until less than 16KB is freed in one operation.
	 * Should be called from the main thread.
	 */
	public static function compact():Void
	{
		#if cpp
		Gc.compact();
		#elseif hl
		Gc.major();
		#end
	}
}
