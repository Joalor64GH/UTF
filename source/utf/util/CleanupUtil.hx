package utf.util;

import flixel.FlxG;
import flixel.FlxState;
import openfl.utils.AssetCache;
import openfl.utils.Assets;
#if polymod
import polymod.Polymod;
#end
#if (cpp || neko || hl)
import utf.util.MemoryUtil;
#end
import utf.util.TimerUtil;

/**
 * Utility class for handling state-related cache management and garbage collection in HaxeFlixel.
 */
class CleanupUtil
{
	/**
	 * Initializes the cleanup utility by setting up pre-state create and post-state switch event listeners.
	 */
	public static function init():Void
	{
		#if (cpp || neko || hl)
		MemoryUtil.enable();
		#end

		FlxG.signals.preStateCreate.add(onPreStateCreate);

		#if (cpp || neko || hl)
		FlxG.signals.postStateSwitch.add(onPostStateSwitch);
		#end
	}

	@:noCompletion
	private static inline function onPreStateCreate(state:FlxState):Void
	{
		final cache:AssetCache = cast(Assets.cache, AssetCache);

		for (key in cache.sound.keys())
		{
			FlxG.log.notice('Removing "$key" from the sound cache.');

			cache.sound.remove(key);
		}

		for (key in cache.font.keys())
		{
			FlxG.log.notice('Removing "$key" from the font cache.');

			cache.font.remove(key);
		}

		#if polymod
		Polymod.clearCache();
		#end
	}

	#if (cpp || neko || hl)
	@:noCompletion
	private static inline function onPostStateSwitch():Void
	{
		FlxG.log.notice('Running the garbage collector.');

		final gcStart:Float = TimerUtil.start();

		MemoryUtil.collect(true);
		MemoryUtil.compact();
		MemoryUtil.collect(false);

		FlxG.log.notice('Garbage collection took: ${TimerUtil.seconds(gcStart)}');
	}
	#end
}
