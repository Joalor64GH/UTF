package utf.util;

import flixel.FlxG;
import flixel.FlxState;
import polymod.Polymod;
#if (cpp || neko || hl)
import utf.util.MemoryUtil;
#end
import utf.util.TimerUtil;

/**
 * Utility class for handling state-related cache management and garbage collection in HaxeFlixel.
 */
@:access(utf.AssetPaths)
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

		final cacheClearingStart:Float = TimerUtil.start();

		for (key in cache.sound.keys())
		{
			if (!AssetPaths.PERSISTENT_SOUNDS.contains(key))
			{
				FlxG.log.notice('Removing "$key" from the sound cache.');

				cache.removeSound(key);
			}
		}

		for (key in cache.font.keys())
		{
			if (!AssetPaths.PERSISTENT_FONTS.contains(key))
			{
				FlxG.log.notice('Removing "$key" from the font cache.');

				cache.removeFont(key);
			}
		}

		FlxG.log.notice('Cache clearing took: ${TimerUtil.seconds(soundClearingStart)}');
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
